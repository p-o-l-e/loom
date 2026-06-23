#pragma once
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include "field/field.h"
#include "modules/modules.h"
#include "s7/s7.h"

const char layout_scm[] = {
    #embed "modules/layout.scm"
};

const char init_scm[] = {
    #embed "modules/init.scm"
};

const char vco_scm[] = {
    #embed "modules/vco.scm"
};




static s7_pointer s7_sector_descriptor(s7_scheme *s7, s7_pointer args) {
    SectorDescriptor* desc = (SectorDescriptor*)malloc(sizeof(SectorDescriptor));
    desc->id                = s7_integer                (s7_list_ref(s7, args, 0));
    desc->node_id           = s7_integer                (s7_list_ref(s7, args, 1));
    desc->bounds.l          = s7_integer                (s7_list_ref(s7, args, 2));
    desc->bounds.t          = s7_integer                (s7_list_ref(s7, args, 3));
    desc->bounds.w          = s7_integer                (s7_list_ref(s7, args, 4));
    desc->bounds.h          = s7_integer                (s7_list_ref(s7, args, 5));
    desc->type              = (SectorType)s7_integer    (s7_list_ref(s7, args, 6));
    desc->subtype           = (SubType)s7_integer       (s7_list_ref(s7, args, 7));
    desc->default_value     = (float)s7_real            (s7_list_ref(s7, args, 8)); 
    desc->range[0]          = (float)s7_real            (s7_list_ref(s7, args, 9)); 
    desc->range[1]          = (float)s7_real            (s7_list_ref(s7, args, 10)); 
    desc->step[CP_COARSE]   = (float)s7_real            (s7_list_ref(s7, args, 11));
    desc->step[CP_FINE]     = (float)s7_real            (s7_list_ref(s7, args, 12));
    desc->radio_id          = s7_integer                (s7_list_ref(s7, args, 13));
    
    s7_pointer str_arg      = s7_list_ref(s7, args, 14);
    if (s7_is_string(str_arg)) {
        const char* tmp     = s7_string(str_arg);
        desc->label         = strdup(tmp);
    } 
    else {
        desc->label         = NULL;
    }

    desc->flags             = s7_integer              (s7_list_ref(s7, args, 15));
    desc->output            = s7_integer              (s7_list_ref(s7, args, 16));

    return s7_make_c_pointer(s7, desc);
}

void bindGuiConstants(s7_scheme *s7) {
    s7_define_variable(s7, "ST_SLIDER",             s7_make_integer(s7, ST_SLIDER));
    s7_define_variable(s7, "ST_ROTARY",             s7_make_integer(s7, ST_ROTARY));
    s7_define_variable(s7, "ST_SPRITE_INF_SLIDER",  s7_make_integer(s7, ST_SPRITE_INF_SLIDER));
    s7_define_variable(s7, "ST_SOCKET",             s7_make_integer(s7, ST_SOCKET));
    s7_define_variable(s7, "ST_CHECKBOX",           s7_make_integer(s7, ST_CHECKBOX));
    s7_define_variable(s7, "ST_SPRITE_CHECKBOX",    s7_make_integer(s7, ST_SPRITE_CHECKBOX));
    s7_define_variable(s7, "ST_SPRITE_BUTTON",      s7_make_integer(s7, ST_SPRITE_BUTTON));
    s7_define_variable(s7, "ST_CANVAS",             s7_make_integer(s7, ST_CANVAS));
    s7_define_variable(s7, "ST_MOMENTARY",          s7_make_integer(s7, ST_MOMENTARY));
    s7_define_variable(s7, "ST_TEXTBOX",            s7_make_integer(s7, ST_TEXTBOX));
    s7_define_variable(s7, "ST_NODE",               s7_make_integer(s7, ST_NODE));

    s7_define_variable(s7, "SS_A",                  s7_make_integer(s7, SS_A));
    s7_define_variable(s7, "SS_B",                  s7_make_integer(s7, SS_B));

    s7_define_variable(s7, "CP_COARSE",             s7_make_integer(s7, CP_COARSE));
    s7_define_variable(s7, "CP_FINE",               s7_make_integer(s7, CP_FINE));

    s7_define_variable(s7, "VERTICAL",              s7_make_integer(s7, VERTICAL));
    s7_define_variable(s7, "MOVEABLE",              s7_make_integer(s7, MOVEABLE));
    s7_define_variable(s7, "INTERCON",              s7_make_integer(s7, INTERCON));
    s7_define_variable(s7, "INPUT",                 s7_make_integer(s7, INPUT));
    s7_define_variable(s7, "OUTPUT",                s7_make_integer(s7, OUTPUT));
    s7_define_variable(s7, "TRANSPARENT",           s7_make_integer(s7, TRANSPARENT));
    s7_define_variable(s7, "RADIO",                 s7_make_integer(s7, RADIO));

    s7_define_function(s7, "create-sector-descriptor", s7_sector_descriptor, 17, 0, false,
        "(create-sector-descriptor id node_id l t w h width height type subtype default min max step_coarse step_fine radio_id flags)");
}


