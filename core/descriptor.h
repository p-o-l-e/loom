#pragma once
#include <stdint.h>

typedef struct core_descriptor core_descriptor;

struct core_descriptor {
    uint32_t cc;
    uint32_t ic;
    uint32_t oc;
};

static const core_descriptor core_fuse_descriptor = { .cc = 0, .ic = 0, .oc = 0 };
