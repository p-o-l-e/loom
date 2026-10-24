#pragma once 
#include <math.h>
#include <stdint.h>
#include "node.h"

typedef struct core_crt core_crt;

static const core_descriptor core_crt_descriptor = { .cc = 0, .ic = 2, .oc = 2 };

struct core_crt {
    enum {
        CCRT_I_X = 0,
        CCRT_I_Y = 1,
    } IN;

    enum {
        CCRT_O_X = 0,
        CCRT_O_Y = 1,
    } OUT;
};

void core_crt_process(const core_node* node) {
    // node->ocv[CCRT_O_X] = *node->icv[CCRT_I_X];
    // node->ocv[CCRT_O_Y] = *node->icv[CCRT_I_Y];

}
