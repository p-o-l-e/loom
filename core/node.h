#pragma once
#include <stdint.h>
#include <sys/types.h>
#include "descriptor.h"
#include "common.h"

static float const fuse = 0.0f;
constexpr float pi  = 3.14159265358979323846f;
constexpr float tao = 6.28318530717958647692f;

typedef struct core_node core_node;
typedef struct core_rack core_rack;

struct core_node {
    float const** ccv;
    float const** icv;
    float* ocv;
    void (*process)(core_node* this);
    core_descriptor const* descriptor;
    void* data;
    bool bypass;
    uint32_t uid;
    core_module_type type;
};

struct core_rack {
    core_node* node;
    uint32_t nodes;
    uint32_t capacity;
};

static void core_fuse_process(core_node*) {}
