#pragma once
#include <pthread.h>
#include <stdatomic.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
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
