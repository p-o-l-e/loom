#pragma once
#include <stdint.h>
#include <stdlib.h>
#include <sys/types.h>
#include "common.h"
#include "uid.h"

static float const fuse = 0.0f;
constexpr float pi  = 3.14159265358979323846f;
constexpr float tao = 6.28318530717958647692f;

typedef struct core_descriptor core_descriptor;
typedef struct core_node core_node;
typedef struct core_rack core_rack;

struct core_descriptor {
    uint32_t cc;
    uint32_t ic;
    uint32_t oc;
};

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

static inline void core_init_node(core_node* node, core_module_type type, core_descriptor const* descriptor, void* data, void (*process)(core_node*), uint32_t id) {
    node->type = type;
    node->descriptor = descriptor;
    node->data = data;
    node->process = process;
    node->bypass = false;

    node->ccv = malloc(descriptor->cc * sizeof(float*));
    node->icv = malloc(descriptor->ic * sizeof(float*));
    node->ocv = malloc(descriptor->oc * sizeof(float));

    for(uint32_t i = 0; i < descriptor->cc; ++i) node->ccv[i] = &fuse;
    for(uint32_t i = 0; i < descriptor->ic; ++i) node->icv[i] = &fuse;

    node->uid = id;
}

static inline void core_destroy_node(core_node* node) {
    free(node->ocv);
    free((void*)node->icv);
    free((void*)node->ccv);
    if(node->data) free(node->data);
}

static inline core_rack* core_create_rack(uint32_t capacity) {
    core_rack* rack = malloc(sizeof(core_rack));
    if (!rack) return NULL;

    rack->node = calloc(capacity, sizeof(core_node));
    rack->nodes = 0;
    rack->capacity = capacity;
    return rack;
}

static inline void core_destroy_rack(core_rack* rack) {
    if (!rack) return;
    for (uint32_t i = 0; i < rack->nodes; ++i) {
        core_destroy_node(&rack->node[i]);
    }
    free(rack->node);
    free(rack);
}
