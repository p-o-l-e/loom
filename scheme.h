#pragma once
#include <stdint.h>
#include "field/field.h"
#include "s7/s7.h"

const char init_scm[] = {
#embed "init.scm"
};

typedef struct sector_descriptor sector_descriptor;

struct sector_descriptor {
    uint32_t    id;
    ltwh32u     bounds;
    SectorType  type;
    SubType     subtype;
    float       default_value;
    float       range[2];
    float       step[CP_LIMIT];
    uint32_t    radio_id;
    uint32_t    flags;
};

static s7_pointer s7_sector_descriptor(s7_scheme *s7, s7_pointer args) {
    sector_descriptor* desc = (sector_descriptor*)malloc(sizeof(sector_descriptor));
    desc->id                = s7_integer                (s7_list_ref(s7, args, 0));
    desc->bounds.l          = s7_integer                (s7_list_ref(s7, args, 1));
    desc->bounds.t          = s7_integer                (s7_list_ref(s7, args, 2));
    desc->bounds.w          = s7_integer                (s7_list_ref(s7, args, 3));
    desc->bounds.h          = s7_integer                (s7_list_ref(s7, args, 4));
    desc->type              = (SectorType)s7_integer    (s7_list_ref(s7, args, 5));
    desc->subtype           = (SubType)s7_integer       (s7_list_ref(s7, args, 6));
    desc->default_value     = (float)s7_real            (s7_list_ref(s7, args, 7)); 
    desc->range[0]          = (float)s7_real            (s7_list_ref(s7, args, 8)); 
    desc->range[1]          = (float)s7_real            (s7_list_ref(s7, args, 9)); 
    desc->step[CP_COARSE]   = (float)s7_real            (s7_list_ref(s7, args, 10));
    desc->step[CP_FINE]     = (float)s7_real            (s7_list_ref(s7, args, 11));
    desc->radio_id          = s7_integer                (s7_list_ref(s7, args, 12));
    desc->flags             = s7_integer                (s7_list_ref(s7, args, 13));

    return s7_make_c_pointer(s7, desc);
}

void bind_gui_primitives(s7_scheme *s7) {
    s7_define_variable(s7, "ST_SLIDER",     s7_make_integer(s7, ST_SLIDER));
    s7_define_variable(s7, "ST_ROTARY",     s7_make_integer(s7, ST_ROTARY));
    s7_define_variable(s7, "ST_SOCKET",     s7_make_integer(s7, ST_SOCKET));
    s7_define_variable(s7, "ST_CHECKBOX",   s7_make_integer(s7, ST_CHECKBOX));
    s7_define_variable(s7, "ST_TEXTBOX",    s7_make_integer(s7, ST_TEXTBOX));
    s7_define_variable(s7, "ST_NODE",       s7_make_integer(s7, ST_NODE));

    s7_define_variable(s7, "SS_A",          s7_make_integer(s7, SS_A));
    s7_define_variable(s7, "SS_B",          s7_make_integer(s7, SS_B));

    s7_define_variable(s7, "CP_COARSE",     s7_make_integer(s7, CP_COARSE));
    s7_define_variable(s7, "CP_FINE",       s7_make_integer(s7, CP_FINE));

    s7_define_variable(s7, "MOVEABLE",      s7_make_integer(s7, MOVEABLE));
    s7_define_variable(s7, "TRANSPARENT",   s7_make_integer(s7, TRANSPARENT));
    s7_define_variable(s7, "INTERCON",      s7_make_integer(s7, INTERCON));
    s7_define_variable(s7, "OUTPUT",        s7_make_integer(s7, OUTPUT));

    s7_define_function(s7, "make-sector-descriptor", s7_sector_descriptor, 14, 0, false,
        "(make-sector-descriptor id l t r b width height type subtype default min max step_coarse step_fine radio_id flags)");
}

