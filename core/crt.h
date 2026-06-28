#pragma once 
#include <math.h>
#include <stdint.h>
#include "node.h"

typedef struct core_crt core_crt;

static const core_descriptor core_generator_descriptor = { .cc = 0, .ic = 2, .oc = 2 };

struct core_crt {
    enum {
        CCRT_I_X = 0,
        CCRT_I_Y = 1,
    } I;

    enum {
        CCRT_O_X = 0,
        CCRT_O_Y = 1,
    } O;
};

void core_crt_process(core_node* node) {
    node->ocv[CCRT_O_X] = *node->icv[CCRT_I_X];
    node->ocv[CCRT_O_Y] = *node->icv[CCRT_I_Y];

}
