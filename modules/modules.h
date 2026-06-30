#pragma once
#include "../core/common.h"
#include "../s7/s7.h"
#include "../field/field.h"
#include <stdio.h>

const char layout_scm[] = {
    #embed "layout.scm"
};

const char init_scm[] = {
    #embed "init.scm"
};

const char vco_scm[] = {
    #embed "vco.scm"
};

const char generator_scm[] = {
    #embed "generator.scm"
};

const char crt_scm[] = {
    #embed "crt.scm"
};

void bindModuleDefinitions(s7_scheme *s7) {
    s7_define_variable(s7, "CMT_FUSE", s7_make_integer(s7, CMT_FUSE));
    s7_define_variable(s7, "CMT_GENERATOR", s7_make_integer(s7, CMT_GENERATOR));
    s7_define_variable(s7, "CMT_VCO", s7_make_integer(s7, CMT_VCO));
    s7_define_variable(s7, "CMT_CRT", s7_make_integer(s7, CMT_CRT));
    s7_define_variable(s7, "CMT_LIMIT", s7_make_integer(s7, CMT_LIMIT));
}

static int load_dimension(s7_scheme* s7, const char* prefix, const char* suffix, int* out) {
    char buf[256];
    snprintf(buf, sizeof(buf), "%s-%s", prefix, suffix);
    s7_pointer val = s7_name_to_value(s7, buf);
    if (val == s7_undefined(s7) || !s7_is_integer(val)) {
        fprintf(stderr, "[load_module] '%s' not found or not an integer\n", buf);
        return -1;
    }
    *out = s7_integer(val);
    return 0;
}

static int load_descriptor(s7_scheme* s7, const char* prefix, s7_pointer* out) {
    char buf[256];
    snprintf(buf, sizeof(buf), "(%s-descriptor)", prefix);
    s7_pointer obj = s7_eval_c_string(s7, buf);
    if (!s7_is_list(s7, obj)) {
        fprintf(stderr, "[load_module] '%s' is not a list\n", buf);
        return -1;
    }
    *out = obj;
    return 0;
}

static Node* load_module(s7_scheme* s7, Field* context, const char* prefix) {
    int w, h;
    if (load_dimension(s7, prefix, "width", &w) < 0) return nullptr;
    if (load_dimension(s7, prefix, "height", &h) < 0) return nullptr;

    s7_pointer list_obj;
    if (load_descriptor(s7, prefix, &list_obj) < 0) return nullptr;

    int entities = s7_list_length(s7, list_obj);
    char buf[256];
    //printf("---- Entities : %lld\n", entities);

    auto node = ffCreateNode(context, w, h, entities);
    int module_id;
    if (load_dimension(s7, prefix, "id", &module_id) == 0)
        node->uid = module_id;
    int len = s7_list_length(s7, list_obj);
    for (int i = 0; i < len; i++) {
        s7_pointer item = s7_list_ref(s7, list_obj, i);
        if (!s7_is_c_pointer(item)) {
            fprintf(stderr, "[load_module] '%s' item %d is not a C pointer\n", prefix, i);
            continue;
        }
        SectorDescriptor* sd = (SectorDescriptor*)s7_c_pointer(item);
        // printf("Descriptor %d: id=%u type=%d bounds=(%u,%u,%u,%u) output=%u\n",
        //     i, sd->id, sd->type,
        //     sd->bounds.l, sd->bounds.t, sd->bounds.w, sd->bounds.h, sd->output);
        ffCreateEntity(node, sd);
    }

    snprintf(buf, sizeof(buf), "%s-id", prefix);
    s7_pointer sym = s7_symbol_table_find_name(s7, buf);
    if (sym) {
        s7_pointer val = s7_symbol_value(s7, sym);
        if (s7_is_integer(val)) {
            printf("Before : %lld\n", s7_integer(val));
            s7_symbol_set_value(s7, sym, s7_make_integer(s7, s7_integer(val) + 1));
            printf("After  : %lld\n", s7_integer(val));

        }
    }
    return node;
}
