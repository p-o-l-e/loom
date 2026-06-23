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

typedef struct SectorDescriptor SectorDescriptor;

struct SectorDescriptor {
    uint32_t    id;
    uint32_t    node_id;
    ltwh32u     bounds;
    SectorType  type;
    SubType     subtype;
    float       default_value;
    float       range[2];
    float       step[CP_LIMIT];
    uint32_t    radio_id;
    char*       label;
    uint32_t    flags;
    uint32_t    output;
};

Entity* find_sector_by_id(Field* restrict o, uint32_t id) {
    if(!id) return nullptr;

    for(uint32_t i = 0; i <= o->Entitys; ++i) {
        if(o->at[i].uid == id) return &o->at[i];
    }
    return nullptr;
}

Entity* createSectorD(Field* restrict o, SectorDescriptor* d) {
    auto pos = ++o->Entitys;
    auto s = &o->at[pos];

    s->uid                       = d->id;
    s->type                     = d->type;
    s->bounds.l                 = d->bounds.l;
    s->bounds.t                 = d->bounds.t;
    s->bounds.r                 = d->bounds.l + d->bounds.w;
    s->bounds.b                 = d->bounds.t + d->bounds.h;
    s->width                    = d->bounds.w;
    s->height                   = d->bounds.h;
    s->value[CP_COARSE]         = (float)(int)d->default_value;
    s->value[CP_FINE]           = d->default_value - (float)(int)d->default_value;
    s->range[0]                 = d->range[0];
    s->range[1]                 = d->range[1];

    s->repaint                  = true;
    s->flags                    = d->flags;
    s->carrier                  = o;

    printf("Created sector : %u\n", s->index);

    switch (d->type) {
        case ST_CHECKBOX: {
            s->extension = (Checkbox*)malloc(sizeof(Checkbox));
            auto ext = (Checkbox*)s->extension;
            ext->radio_id = d->radio_id;
        }
        break;

        case ST_SLIDER: {
            s->extension = (Slider*)malloc(sizeof(Slider));
            auto ext = (Slider*)s->extension;
            ext->type = d->subtype;
            ext->default_value = d->default_value; 
            ext->step[CP_COARSE] = d->step[CP_COARSE];
            ext->step[CP_FINE] = d->step[CP_FINE];
        }
        break;

        case ST_SOCKET: {
            s->extension = (Socket*)malloc(sizeof(Socket));
        }
        break;

        default: 
        break;
    
    }

    for(uint32_t i = 0; i < CT_LIMIT; ++i) {
        s->callback[i] = &fuse_link;
    }

    if(!(d->flags & TRANSPARENT)) {
        draw_ltrb_f (
            o->layer[SC],
            &s->bounds,
            s->index
        );
    }

    init_sector[d->type](s);
    if(d->type == ST_TEXTBOX) {
        strncpy(s->data, d->label, TEXTBOX_SIZE);
    }

    if(d->output) {
        printf("---- Set output : %d\n", d->output);
        auto target = find_sector_by_id(o, d->output);
        if(target) {
            add_mod_link(s, target, CT_VALUE, value_to_textbox);
            printf("---- Target found...\n");
        }
        else
            printf("---- NO Target found...\n");
    }

    auto node = find_sector_by_id(o, d->node_id);
    if(node)
        link_sector(node, s);

    return s;
}

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


