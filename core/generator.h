#pragma once 
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include "node.h"

typedef struct core_generator core_generator;

static const core_descriptor core_generator_descriptor = { .cc = 3, .ic = 0, .oc = 1 };

struct core_generator {
    enum {
        CG_C_COARSE = 0,
        CG_C_FINE,   
        CG_C_AMP  
    } C;
    enum {
        CG_O_A      = 0,
    } O;
    float delta;
    float phase;
};

void core_generator_process(core_node* node) {
    core_generator* generator = (core_generator*)node->data;
    generator->phase += (*node->ccv[CG_C_COARSE] + *node->ccv[CG_C_FINE]) * 0.001f;
    if(generator->phase > pi) generator->phase -= tao;
    node->ocv[CG_O_A] = cosf(generator->phase) * *node->ccv[CG_C_AMP];
}
