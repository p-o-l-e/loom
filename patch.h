#pragma once
/* patch.h — Scheme bindings for patch construction.
 *
 * Included at the end of bridge.h (after core_bind_module is defined).
 * Exposes C functions to Scheme so that patches/init.scm can declaratively
 * describe the module layout: which modules to instantiate, where to place
 * them, which core nodes to create, and how to wire them together.
 *
 * Design: Scheme is the steering wheel. The C side owns the Field, the s7
 * interpreter, and the frame loop. Scheme owns the patch topology. */

#include <stdio.h>
#include "scheme.h"
#include "core/core.h"
#include "bridge.h"

/* Wiring callback — connects patch-level UI controls to their actions.
 * Implemented in links.h (wire_controls). Passed to loadPatch so the
 * caller decides which wiring to apply. */
typedef void (*PatchWireFn)(s7_scheme* s7, Field* field);

/* (internal) Fetch the patch field from the Scheme environment.
 * bindPatchFunctions publishes it as the Scheme variable *field* (a
 * c-pointer to the Field). Returns nullptr if the variable is unset. */
static Field* patch_field(s7_scheme* s7) {
    s7_pointer v = s7_name_to_value(s7, "*field*");
    if (!s7_is_c_pointer(v)) return nullptr;
    return (Field*)s7_c_pointer(v);
}

/* --- Patch-session domain logic ------------------------------------------ */
/* Registry, save machinery, and helpers. This is NOT connection/wiring
 * logic — links.h only maps UI events to actions (SAVE button → saver).
 * The hooks below are called from the Scheme bindings to record state. */

/* Registry of place-node calls — the metadata needed to serialise the live
 * patch back to a .scm layout file (see patch_save_current). Position is not
 * stored here: it is read from each node's ST_NODE entity bounds at save time
 * so drags and window-resize re-anchoring are reflected. */
typedef struct {
    Node*       node;                       /* GUI node handle. */
    char        prefix[32];                 /* Module prefix, e.g. "vco". */
    bool        has_core;                   /* A core node was created+bound. */
    uint32_t    core_type;                  /* core_module_type when has_core. */
} PatchModule;

#define PATCH_MODULE_LIMIT 64

static PatchModule g_patch_modules[PATCH_MODULE_LIMIT];
static uint32_t    g_patch_module_count = 0;

/* Rack capacity from the (create-rack capacity) call — recorded so the saver
 * can emit a faithful (create-rack N) line without holding the rack itself.
 * The rack handle lives in Scheme and flows through place-node/start-core. */
static uint32_t    g_rack_capacity = 0;

/* (internal) Record one place-node call — called from s7_place_node. */
static void patch_note_module(Node* node, const char* prefix, bool has_core,
                              uint32_t core_type) {
    if (g_patch_module_count >= PATCH_MODULE_LIMIT) return;
    PatchModule* m = &g_patch_modules[g_patch_module_count++];
    m->node      = node;
    m->has_core  = has_core;
    m->core_type = core_type;
    snprintf(m->prefix, sizeof(m->prefix), "%s", prefix);
}

/* (internal) Record the rack capacity — called from s7_create_rack. */
static void patch_note_rack_capacity(uint32_t capacity) {
    g_rack_capacity = capacity;
}

/* (internal) Scheme-visible name of a core module type, matching the
 * variables bound by bindModuleDefinitions (modules.h). */
static const char* patch_core_type_name(core_module_type type) {
    switch (type) {
        case CMT_GENERATOR: return "CMT_GENERATOR";
        case CMT_VCO:       return "CMT_VCO";
        case CMT_CRT:       return "CMT_CRT";
        case CMT_SPLIT:     return "CMT_SPLIT";
        case CMT_MAINMENU:  return "CMT_MAINMENU";
        case CMT_FUSE:
        default:            return "CMT_FUSE";
    }
}

/* (internal) Current screen position of a module node: the bounds of its
 * ST_NODE (frame) entity — the same source ff_anchor_node/ff_release_node
 * use, so drags and resize re-anchoring are reflected. */
static void patch_node_position(Node* restrict node, uint32_t* x, uint32_t* y) {
    for (uint32_t i = 0; i < node->entities; ++i) {
        if (node->at[i].type == ST_NODE) {
            *x = node->at[i].bounds.l;
            *y = node->at[i].bounds.t;
            return;
        }
    }
    *x = 0;
    *y = 0;
}

/** @brief Serialise the live patch to a .scm layout file.
 *  @param field  The patch field (canvas) holding the modules.
 *  @param path   Destination file (e.g. "../patches/save.scm").
 *  @details Emits a patch structured like patches/init.scm: rack creation,
 *           one place-node call per placed module (with core binding when
 *           present), cord connections, control values, then set-crt-fps /
 *           start-core.
 *
 *           Runs on the event thread from the menu SAVE button (wired in
 *           links.h) — user-triggered and off the frame loop — and performs
 *           no Scheme evaluation, so the C↔Scheme boundary is not crossed.
 *           Only immutable rack metadata (capacity) and node bounds are
 *           read; a concurrent drag may tear a coordinate, which is
 *           harmless for a saved layout. */
static void patch_save_current(Field* field, const char* path) {
    FILE* f = fopen(path, "w");
    if (!f) {
        fprintf(stderr, "[PATCH] failed to open '%s' for writing\n", path);
        return;
    }

    uint32_t fps = 60;
    if (field->stream[0] && field->stream[0]->extension)
        fps = ((Oscillograph*)field->stream[0]->extension)->fps;

    uint32_t capacity = g_rack_capacity ? g_rack_capacity : 16;

    fprintf(f, "#|\n"
               " | patches/save.scm — saved patch layout.\n"
               " |\n"
               " | Written by the menu SAVE button (patch.h:patch_save_current).\n"
               " | Mirrors patches/init.scm: creates the core rack, instantiates and\n"
               " | places modules, wires them to core nodes, restores cord\n"
               " | connections, and starts the processing thread.\n"
               " |\n"
               " | Each connect-sockets call is one cable:\n"
               " |   (connect-sockets output-socket-uid input-socket-uid)\n"
               " |\n"
               " | Each set-control call is one control value:\n"
               " |   (set-control control-uid value)\n"
               " |#\n\n");
    fprintf(f, "(define FPS %u)\n\n", (unsigned)fps);

    fprintf(f, ";;--------------------------------------------------------------------------\n"
               ";; Core rack — the DSP-side processing graph.\n"
               ";;--------------------------------------------------------------------------\n\n");
    fprintf(f, "(define rack (create-rack %u))\n\n", (unsigned)capacity);

    fprintf(f, ";;--------------------------------------------------------------------------\n"
               ";; Modules — one place-node call per module.\n"
               ";; With core-type + uid: load GUI + create core node + place + bind.\n"
               ";; Without: load GUI + place only (menu, CRT, unbound generators).\n"
               ";;--------------------------------------------------------------------------\n\n");

    for (uint32_t i = 0; i < g_patch_module_count; ++i) {
        PatchModule* m = &g_patch_modules[i];
        if (!m->node || !m->node->visible) continue;
        uint32_t x, y;
        patch_node_position(m->node, &x, &y);
        /* Quote the prefix first, then pad the quoted unit — padding inside
         * the quotes would change the module name string. Column layout
         * matches patches/init.scm. Sized for prefix + quotes + NUL. */
        char qprefix[sizeof(m->prefix) + 3];
        snprintf(qprefix, sizeof(qprefix), "\"%s\"", m->prefix);
        if (m->has_core)
            fprintf(f, "(place-node rack %-12s%-4u%-4u %s)\n",
                    qprefix, (unsigned)x, (unsigned)y,
                    patch_core_type_name((core_module_type)m->core_type));
        else
            fprintf(f, "(place-node rack %-12s%-4u%u)\n",
                    qprefix, (unsigned)x, (unsigned)y);
    }

    fprintf(f, "\n;;--------------------------------------------------------------------------\n"
               ";; Cord connections — one connect-sockets call per cable (output → input).\n"
               ";;--------------------------------------------------------------------------\n\n");

    /* One line per cable, emitted from the output end so each connection
     * appears exactly once (both ends carry connected/connection). */
    uint32_t connections = 0;
    for (uint32_t n = 0; n < field->nodes; ++n) {
        Node* node = &field->node[n];
        if (!node->visible) continue;
        for (uint32_t i = 0; i < node->entities; ++i) {
            Entity* e = &node->at[i];
            if (e->type != ST_SOCKET || e->core_type != F_CT_OUTPUT) continue;
            auto ext = (Socket*)e->extension;
            if (!ext->connected || !ext->connection) continue;
            fprintf(f, "(connect-sockets #x%x #x%x)\n",
                    (unsigned)e->uid, (unsigned)ext->connection->uid);
            ++connections;
        }
    }

    fprintf(f, "\n;;--------------------------------------------------------------------------\n"
               ";; Control values — one set-control call per control (slider, encoder,\n"
               ";; checkbox). Value is the displayed total (coarse + fine).\n"
               ";;--------------------------------------------------------------------------\n\n");

    uint32_t controls = 0;
    for (uint32_t n = 0; n < field->nodes; ++n) {
        Node* node = &field->node[n];
        if (!node->visible) continue;
        for (uint32_t i = 0; i < node->entities; ++i) {
            Entity* e = &node->at[i];
            if (e->core_type != F_CT_CONTROL) continue;
            /* %.9g round-trips an IEEE-754 float exactly through decimal. */
            float total = e->value[CP_COARSE] + e->value[CP_FINE];
            fprintf(f, "(set-control #x%x %.9g)\n", (unsigned)e->uid, (double)total);
            ++controls;
        }
    }

    fprintf(f, "\n;;--------------------------------------------------------------------------\n"
               ";; CRT display refresh rate.\n"
               ";;--------------------------------------------------------------------------\n\n");
    fprintf(f, "(set-crt-fps FPS)\n\n");

    fprintf(f, ";;--------------------------------------------------------------------------\n"
               ";; Start the core processing thread (runs in the background).\n"
               ";;--------------------------------------------------------------------------\n\n");
    fprintf(f, "(start-core rack FPS)\n");

    fclose(f);
    printf("[PATCH] saved %u modules, %u connections, %u controls to %s\n",
           (unsigned)g_patch_module_count, (unsigned)connections,
           (unsigned)controls, path);
}

/* (load-module "prefix") -> node-handle (c-pointer to Node).
 * Evaluates <prefix>-descriptor, <prefix>-width, <prefix>-height from the
 * Scheme environment and instantiates the GUI node. The C load_module helper
 * auto-increments <prefix>-id so repeated calls create unique instances. */
static s7_pointer s7_load_module(s7_scheme* s7, s7_pointer args) {
    const char* prefix = s7_string(s7_list_ref(s7, args, 0));
    Node* node = load_module(s7, patch_field(s7), prefix);
    return s7_make_c_pointer(s7, node);
}

/* (place-node rack prefix x y [core-type]) -> node-handle.
 * High-level patch-construction primitive — one call per module:
 *   1. load-module: instantiate the GUI module from Scheme definitions
 *   2. ffPlaceNode: position it on the canvas at (x, y)
 *   3. (optional) rack-add-node + bind-module: create a core node and wire
 *      the GUI module's controls/sockets to the core node's ccv/icv/ocv
 *
 *   rack       — rack handle from create-rack
 *   prefix     — module prefix string (e.g. "generator", "vco", "menu")
 *   x, y       — pixel position on the canvas
 *   core-type  — optional: core module type (CMT_GENERATOR, CMT_VCO, ...)
 *
 * Without core-type, only the GUI module is loaded and placed
 * (e.g. menu bars, CRTs, or generators not bound to the core). Returns
 * the GUI node handle (c-pointer) for later use.
 *
 * Note: no core-uid argument — the core node's UID is never read by the
 * engine (core_bind_module matches on module->type + GUI node->uid). */
static s7_pointer s7_place_node(s7_scheme* s7, s7_pointer args) {
    core_rack*  rack   = (core_rack*)s7_c_pointer(s7_list_ref(s7, args, 0));
    const char* prefix = s7_string(s7_list_ref(s7, args, 1));
    uint32_t    x      = (uint32_t)s7_integer(s7_list_ref(s7, args, 2));
    uint32_t    y      = (uint32_t)s7_integer(s7_list_ref(s7, args, 3));
    Field*      field  = patch_field(s7);

    /* 1. Load the GUI module from Scheme definitions. */
    Node* node = load_module(s7, field, prefix);
    if (!node) return s7_make_c_pointer(s7, nullptr);

    /* 2. Place it on the canvas. */
    ffPlaceNode(field, node, x, y);

    /* 3. Optionally create a core node and bind GUI ↔ core. */
    s7_int n = s7_list_length(s7, args);
    core_module_type type = CMT_FUSE;
    if (n >= 5) {
        type = (core_module_type)s7_integer(s7_list_ref(s7, args, 4));
        uint32_t index = rack->nodes++;
        core_init_node(&rack->node[index], type, 0);
        core_bind_module(node, &rack->node[index]);
    }

    /* 4. Record the module for patch serialisation (menu SAVE button). */
    patch_note_module(node, prefix, n >= 5, (uint32_t)type);

    return s7_make_c_pointer(s7, node);
}

/* (create-rack capacity) -> rack-handle (c-pointer to core_rack).
 * Allocates a core processing rack. The handle is returned to Scheme (and
 * flows through place-node / start-core); the capacity is recorded in
 * patch.h so the saver can emit a faithful (create-rack N) line. */
static s7_pointer s7_create_rack(s7_scheme* s7, s7_pointer args) {
    uint32_t capacity = (uint32_t)s7_integer(s7_list_ref(s7, args, 0));
    core_rack* rack = core_create_rack(capacity);
    patch_note_rack_capacity(capacity);
    return s7_make_c_pointer(s7, rack);
}

/* (rack-add-node rack-handle type id) -> node-index (integer).
 * Appends a core node of the given module type and UID to the rack.
 * Returns the index so Scheme can later pass it to bind-module. */
static s7_pointer s7_rack_add_node(s7_scheme* s7, s7_pointer args) {
    core_rack*       rack  = (core_rack*)s7_c_pointer(s7_list_ref(s7, args, 0));
    core_module_type type  = (core_module_type)s7_integer(s7_list_ref(s7, args, 1));
    uint32_t         id    = (uint32_t)s7_integer(s7_list_ref(s7, args, 2));
    uint32_t         index = rack->nodes++;
    core_init_node(&rack->node[index], type, id);
    return s7_make_integer(s7, (s7_int)index);
}

/* (bind-module rack node-handle core-node-index) -> unspecified.
 * Wires a GUI module (Node*) to a core node by matching entity UIDs.
 * The GUI module's control values, input sockets, and output sockets are
 * linked to the core node's ccv/icv/ocv arrays. Rack first, matching the
 * place-node convention — no global rack handle. */
static s7_pointer s7_bind_module(s7_scheme* s7, s7_pointer args) {
    core_rack* rack  = (core_rack*)s7_c_pointer(s7_list_ref(s7, args, 0));
    Node*      node  = (Node*)s7_c_pointer(s7_list_ref(s7, args, 1));
    uint32_t   index = (uint32_t)s7_integer(s7_list_ref(s7, args, 2));
    core_bind_module(node, &rack->node[index]);
    return s7_unspecified(s7);
}

/* (set-crt-fps fps) -> unspecified.
 * Sets the refresh rate on the first CRT stream entity (stream[0]).
 * Matches the original main.c behaviour: osc->fps = FPS. */
static s7_pointer s7_set_crt_fps(s7_scheme* s7, s7_pointer args) {
    uint32_t fps = (uint32_t)s7_integer(s7_list_ref(s7, args, 0));
    Field* field = patch_field(s7);
    if (field && field->stream[0]) {
        auto osc = (Oscillograph*)field->stream[0]->extension;
        osc->fps = fps;
    }
    return s7_unspecified(s7);
}

/* (start-core rack-handle fps) -> thread-handle (c-pointer to core_thread).
 * Spawns the core processing thread. The thread runs until the process
 * exits (field_loop calls exit() on window close). */
static s7_pointer s7_start_core(s7_scheme* s7, s7_pointer args) {
    core_rack* rack = (core_rack*)s7_c_pointer(s7_list_ref(s7, args, 0));
    uint32_t   fps  = (uint32_t)s7_integer(s7_list_ref(s7, args, 1));
    core_thread* pt = core_start(rack, fps);
    return s7_make_c_pointer(s7, pt);
}

/* (connect-sockets out-uid in-uid) -> bool.
 * Establish a cord connection between two socket entities by UID. Thin
 * wrapper over ff_connect: resolves both entities in the patch field and
 * wires input ↔ output — core data flow (icv slot) plus the cord spline.
 * Either argument order works; ff_connect rejects incompatible pairs
 * (input→input, output→output). Intended for patch files, evaluated at
 * load time after the place-node calls that create the sockets. */
static s7_pointer s7_connect_sockets(s7_scheme* s7, s7_pointer args) {
    uint32_t uid_a = (uint32_t)s7_integer(s7_list_ref(s7, args, 0));
    uint32_t uid_b = (uint32_t)s7_integer(s7_list_ref(s7, args, 1));
    Field* field = patch_field(s7);
    if (!field) return s7_make_boolean(s7, false);
    Entity* a = ff_find_entity_by_id(field, uid_a);
    Entity* b = ff_find_entity_by_id(field, uid_b);
    if (!a || !b || a->type != ST_SOCKET || b->type != ST_SOCKET)
        return s7_make_boolean(s7, false);
    bool ok = ff_connect(a, b);
    if (ok) {
        /* ff_connect marks the target hovered — correct for a drag-release,
         * where the cursor sits on the target socket and the next mouse move
         * maintains hover. Restoring a saved connection is not an interaction:
         * with no cursor over anything, the stale hover would keep every
         * restored cord highlighted (cords draw selected when either end is
         * hovered). Clear both ends so saved cords draw in normal mode. */
        a->hovered = false;
        b->hovered = false;
    }
    return s7_make_boolean(s7, ok);
}

/* (set-control uid value) -> bool.
 * Restore a control's value (slider, encoder, checkbox, …) by entity UID.
 * value is the displayed total; it is written to value[CP_COARSE] — the slot
 * the core reads through ccv and the one drag handlers write wholesale —
 * with the transient fine slot cleared, so control, textbox and DSP all
 * agree on the restored value. Fires F_CE_VALUE so the paired textbox
 * repaints, exactly as a drag would. Intended for patch files, evaluated
 * at load time after the place-node calls that create the controls. */
static s7_pointer s7_set_control(s7_scheme* s7, s7_pointer args) {
    uint32_t uid = (uint32_t)s7_integer(s7_list_ref(s7, args, 0));
    float    val = (float)s7_real(s7_list_ref(s7, args, 1));
    Field* field = patch_field(s7);
    if (!field) return s7_make_boolean(s7, false);
    Entity* e = ff_find_entity_by_id(field, uid);
    if (!e || e->core_type != F_CT_CONTROL)
        return s7_make_boolean(s7, false);
    e->value[CP_COARSE] = val;
    e->value[CP_FINE]   = 0.0f;
    e->repaint = true;
    e->callback[F_CE_VALUE](e, e->target[F_CE_VALUE]);
    return s7_make_boolean(s7, true);
}

/** @brief Bind patch-construction functions into the s7 environment.
 *  @param s7       s7 interpreter.
 *  @param context  The Field (canvas) that modules are loaded into.
 *  @details Call after bindGuiConstants and bindModuleDefinitions, before
 *           loading patches/init.scm. Publishes the field as the Scheme
 *           variable *field* so bindings can fetch it per call — no global. */
void bindPatchFunctions(s7_scheme* s7, Field* context) {
    s7_define_variable(s7, "*field*", s7_make_c_pointer(s7, context));

    s7_define_function(s7, "load-module", s7_load_module, 1, 0, false,
        "(load-module prefix) -> node-handle. Instantiate a GUI module from Scheme definitions.");

    s7_define_function(s7, "place-node", s7_place_node, 4, 1, false,
        "(place-node rack prefix x y [core-type]) -> node-handle. "
        "Load a GUI module, place it at (x,y), and optionally create+bind a core node. "
        "This is the primary patch-construction primitive — one call per module.");

    s7_define_function(s7, "create-rack", s7_create_rack, 1, 0, false,
        "(create-rack capacity) -> rack-handle. Create a core processing rack.");

    s7_define_function(s7, "rack-add-node", s7_rack_add_node, 3, 0, false,
        "(rack-add-node rack-handle type id) -> node-index. Append a core node to the rack.");

    s7_define_function(s7, "bind-module", s7_bind_module, 3, 0, false,
        "(bind-module rack node-handle core-node-index). Wire a GUI module to a core node.");

    s7_define_function(s7, "set-crt-fps", s7_set_crt_fps, 1, 0, false,
        "(set-crt-fps fps). Set the CRT display refresh rate.");

    s7_define_function(s7, "start-core", s7_start_core, 2, 0, false,
        "(start-core rack-handle fps) -> thread-handle. Start the core processing thread.");

    s7_define_function(s7, "connect-sockets", s7_connect_sockets, 2, 0, false,
        "(connect-sockets out-uid in-uid) -> bool. Connect two socket entities by UID "
        "(restores cord connections when loading a saved patch).");

    s7_define_function(s7, "set-control", s7_set_control, 2, 0, false,
        "(set-control uid value) -> bool. Restore a control's value by entity UID "
        "(saves/restores slider, encoder and checkbox state in patch files).");
}

/** @brief Load a single embedded Scheme source string, logging on error.
 *  @param s7       s7 interpreter.
 *  @param name     Human-readable name for log messages.
 *  @param content  NUL-terminated Scheme source (from #embed).
 *  @param bytes    Content length (excluding NUL; pass sizeof(array) - 1).
 */
static void load_scm_file(s7_scheme* s7, const char* name, const char* content, s7_int bytes) {
    printf("[SCHEME] loading %s\n", name);
    s7_load_c_string(s7, content, bytes);
}

/** @brief Initialise the Scheme environment: bind C functions and load all
 *         embedded module definitions (helpers, layout, module descriptors).
 *  @param s7       s7 interpreter (must be freshly created via s7_init).
 *  @param context  The Field (canvas) passed to patch-construction bindings.
 *  @details Binds GUI constants, core module types, and patch-construction
 *           primitives, then loads the embedded Scheme sources that define
 *           the available module types. Does NOT load a patch — call
 *           loadPatch() separately to instantiate a specific layout.
 *
 *           Load order matters: helpers first (init, layout), then module
 *           definitions (vco, generator, crt, split, menu). */
void initScheme(s7_scheme* s7, Field* context) {
    /* 1. Bind C constants and functions into the Scheme environment. */
    bindGuiConstants(s7);
    bindModuleDefinitions(s7);
    bindPatchFunctions(s7, context);

    /* 2. Load embedded Scheme sources in dependency order.
     *    sizeof - 1: arrays are NUL-terminated (#embed does not add one),
     *    and s7_load_c_string requires content[bytes] == 0. */
    load_scm_file(s7, "modules/init.scm",      init_scm,       sizeof(init_scm) - 1);
    load_scm_file(s7, "modules/layout.scm",    layout_scm,     sizeof(layout_scm) - 1);
    load_scm_file(s7, "modules/vco.scm",       vco_scm,        sizeof(vco_scm) - 1);
    load_scm_file(s7, "modules/generator.scm", generator_scm,  sizeof(generator_scm) - 1);
    load_scm_file(s7, "modules/crt.scm",       crt_scm,        sizeof(crt_scm) - 1);
    load_scm_file(s7, "modules/split.scm",     split_scm,      sizeof(split_scm) - 1);
    load_scm_file(s7, "ui/menu.scm",           mainmenu_scm,   sizeof(mainmenu_scm) - 1);
}

/** @brief Load a patch from a .scm file on disk.
 *  @param s7        s7 interpreter (must have initScheme called first).
 *  @param field     The patch field (canvas) the patch loads into.
 *  @param filename  Path to the patch file (e.g. "patches/init.scm").
 *  @param wire      Wiring callback (e.g. wire_controls from links.h) —
 *                   connects patch-level UI controls after the patch is
 *                   evaluated. May be nullptr to skip wiring.
 *  @details Patches are loaded from the filesystem (not #embed) so they can
 *           be saved, shared, and edited as plain .scm files. The patch file
 *           uses the primitives bound by initScheme (load-module, place-node,
 *           create-rack, rack-add-node, bind-module, set-crt-fps, start-core)
 *           to construct the module layout.
 *
 *           Returns true on success, false if the file could not be loaded. */
bool loadPatch(s7_scheme* s7, Field* field, const char* filename, PatchWireFn wire) {
    printf("[PATCH] loading %s\n", filename);
    s7_pointer result = s7_load(s7, filename);
    if (result == NULL) {
        fprintf(stderr, "[PATCH] failed to load '%s'\n", filename);
        return false;
    }
    /* The patch just (re)created the GUI — wire patch-level UI actions that
     * live outside the descriptor mechanism (menu SAVE button, etc.). */
    if (wire) wire(s7, field);
    return true;
}
