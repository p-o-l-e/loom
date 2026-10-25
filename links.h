/* links.h — connection/wiring business logic.
 *
 * The single entry point is wire_controls(s7, field): reads Scheme-published
 * UIDs and connects UI events to patch-domain actions ("this button does
 * that"). The domain logic itself (module registry, serialisation, type
 * names) lives in patch.h — this file only wires.
 *
 * UIDs are published by the Scheme side (e.g. ui/menu.scm sets
 * menu-save-button-uid during descriptor evaluation) — no hardcoded slot
 * numbers. patch.h includes this file; the forward-declared
 * patch_save_current is defined later in patch.h (same translation unit). */
#pragma once

#include <stdint.h>
#include <stdbool.h>
#include "field/field.h"
#include "s7/s7.h"

/* Destination of the menu SAVE button. Same relative-root convention as
 * loadPatch(s7, context, "../patches/...") in main.c. */
#define PATCH_SAVE_PATH "../patches/save.scm"

/* Forward declaration — the save machinery is defined in patch.h. */
static void patch_save_current(Field* field, const char* path);

/* (internal) F_CE_PRESS handler for the menu SAVE button (ST_MOMENTARY).
 * The framework fixes the callback signature at (Entity*, Entity*); the field
 * is recovered from the pressed entity — no global needed. */
static void patch_menu_save_press(Entity* src, [[maybe_unused]] Entity* target) {
    if (!src || !src->parent) return;
    patch_save_current(src->parent->parent, PATCH_SAVE_PATH);
}

/** @brief Wire all patch-level UI controls to their actions.
 *  @param s7     s7 interpreter (patch must have been evaluated first).
 *  @param field  The patch field (canvas) holding the modules.
 *  @details Called from loadPatch after the patch file has been evaluated.
 *           Reads Scheme-published UIDs and connects events to handlers.
 *           Each control gets its own block; add new wiring here.
 *
 *           The button's descriptor wiring (CallbackEvent F_CE_REPAINT →
 *           textbox repaint) is untouched; this adds handlers in the free
 *           event slots. */
static void wire_controls(s7_scheme* s7, Field* field) {
    /* Menu SAVE button — menu.scm publishes its UID as menu-save-button-uid
     * during descriptor evaluation. Wire the press event to the saver. */
    s7_pointer save_uid_v = s7_name_to_value(s7, "menu-save-button-uid");
    if (s7_is_integer(save_uid_v)) {
        Entity* btn = ff_find_entity_by_id(field, (uint32_t)s7_integer(save_uid_v));
        if (btn)
            ff_add_mod_link(btn, nullptr, F_CE_PRESS, patch_menu_save_press);
    }
}
