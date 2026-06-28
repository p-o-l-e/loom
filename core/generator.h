#pragma once 
#include <math.h>
#include <stdint.h>
#include "node.h"

typedef struct core_generator core_generator;

static const core_descriptor core_generator_descriptor = { .cc = 1, .ic = 1, .oc = 1 };

struct core_generator {
    enum {
        CG_C_DELTA  = 0,
        CG_C_AMP    = 1,
    } C;
    enum {
        CG_O_A      = 0,
    } O;
    float delta;
    float phase;
};

void core_generator_cos(core_node* node) {
    core_generator* generator = (core_generator*)node->data;
    generator->phase += *node->ccv[CG_C_DELTA];
    if(generator->phase > pi) generator->phase -= tao;
    node->ocv[CG_O_A] = cosf(generator->phase) * *node->ccv[CG_C_AMP];
}
