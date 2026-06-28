#pragma once
#include <stdint.h>
#include <stdlib.h>
#include <sys/types.h>
#include "uid.h"
#include "generator.h"
#include "modules.h"

static float const fuse = 0.0f;
constexpr float pi  = 3.14159265358979323846f;
constexpr float tao = 6.28318530717958647692f;

typedef struct core_descriptor core_descriptor;
typedef struct core_node core_node;
typedef struct core_rack core_rack;

typedef enum {
    CMT_FUSE,
    CMT_GENERATOR,
} core_module_type;

struct core_descriptor {
    uint32_t cc;
    uint32_t ic;
    uint32_t oc;
};

struct core_node {
    float const** ccv;
    float const** icv;
    float* ocv;
    void (* const process)(core_node* this);
    core_descriptor const* const descriptor;
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

static inline void core_init_node(core_node* node, core_module_type type, uint32_t id) {
    node->ccv = malloc(node->descriptor->cc * sizeof(float*));
    node->icv = malloc(node->descriptor->ic * sizeof(float*));
    node->ocv = malloc(node->descriptor->oc * sizeof(float));

    for(uint32_t i = 0; i < node->descriptor->cc; ++i) node->ccv[i] = &fuse;
    for(uint32_t i = 0; i < node->descriptor->ic; ++i) node->icv[i] = &fuse;

    switch (type) {
        case CMT_FUSE:
            break;

        case CMT_GENERATOR:
            node->data = malloc(sizeof(core_generator));
            break;

        default:
            node->data = nullptr;
            break;
    }

    node->uid = id;

}

static inline void core_destroy_node(core_node* node) {
    free(node->ocv);
    free((void*)node->icv);
    free((void*)node->ccv);

    switch (node->type) {
        case CMT_FUSE:
            break;

        case CMT_GENERATOR:
            free(node->data);
            break;

        default:
            break;
    }
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
