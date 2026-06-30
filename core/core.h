#pragma once
#include <pthread.h>
#include <stdatomic.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "modules.h"
#include "node.h"

typedef struct {
    pthread_t thread;
    pthread_mutex_t lock;
    atomic_bool on;
    core_rack* rack;
    uint32_t fps;
} core_thread;

static void* core_loop(void* arg) {
    core_thread* pt = (core_thread*)arg;
    struct timespec ts;
    ts.tv_sec = 0;
    ts.tv_nsec = 1000000000 / pt->fps;

    while (pt->on) {
        pthread_mutex_lock(&pt->lock);

        for (uint32_t i = 0; i < pt->rack->nodes; ++i) {
            core_node* node = &pt->rack->node[i];
            if (node->process && !node->bypass) {
                node->process(node);
            }
        }

        pthread_mutex_unlock(&pt->lock);
        nanosleep(&ts, NULL);
    }

    return nullptr;
}

static inline core_thread* core_start(core_rack* rack, uint32_t fps) {
    core_thread* pt = malloc(sizeof(core_thread));
    if (!pt) return NULL;

    pt->rack = rack;
    pt->fps = fps;
    pt->on = true;

    pthread_mutex_init(&pt->lock, NULL);

    if (pthread_create(&pt->thread, NULL, core_loop, pt) != 0) {
        perror("core_start_processing: pthread_create");
        free(pt);
        return NULL;
    }

    return pt;
}

static inline void core_stop(core_thread* pt) {
    if (!pt) return;
    pt->on = false;
    pthread_join(pt->thread, NULL);
    pthread_mutex_destroy(&pt->lock);
    free(pt);
}


/** Node *********************************************************************************************************************/

static void core_init_node(core_node* node, core_module_type type, uint32_t id) {
    switch (type) {
        case CMT_GENERATOR:
            node->descriptor = &core_generator_descriptor;
            node->process = &core_generator_process;
            node->data = malloc(sizeof(core_generator));
            break;
        case CMT_CRT:
            node->descriptor = &core_crt_descriptor;
            node->process = &core_crt_process;
            node->data = malloc(sizeof(core_crt));
            break;
        case CMT_VCO:
        case CMT_FUSE:
        case CMT_LIMIT:
        default:
            node->descriptor = &core_fuse_descriptor;
            node->process = &core_fuse_process;
            node->data = nullptr;
            break;
    }

    node->type = type;
    node->bypass = false;

    node->ccv = malloc(node->descriptor->cc * sizeof(float*));
    node->icv = malloc(node->descriptor->ic * sizeof(float*));
    node->ocv = malloc(node->descriptor->oc * sizeof(float));

    for(uint32_t i = 0; i < node->descriptor->cc; ++i) node->ccv[i] = &fuse;
    for(uint32_t i = 0; i < node->descriptor->ic; ++i) node->icv[i] = &fuse;

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
