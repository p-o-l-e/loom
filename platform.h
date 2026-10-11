#pragma once

#if !defined(_WIN32) && !defined(_WIN64)
#define _XOPEN_SOURCE 600
#define _POSIX_C_SOURCE 200212L
#endif

#include <stdatomic.h>
#include <stdint.h>
#include <stdbool.h>

#if defined(_WIN32) || defined(_WIN64)

#include <windows.h>
#include <process.h>

typedef HANDLE platform_thread_t;

typedef SRWLOCK platform_mutex_t;

typedef struct {
    SRWLOCK          lock;
    CONDITION_VARIABLE cv;
} platform_cond_t;

typedef struct {
    HANDLE   events[2];
    LONG     count;
    LONG     threshold;
    LONG     cycle;
    SRWLOCK  lock;
} platform_barrier_t;

static inline void platform_mutex_init(platform_mutex_t* m) {
    InitializeSRWLock(m);
}

static inline void platform_mutex_lock(platform_mutex_t* m) {
    AcquireSRWLockExclusive(m);
}

static inline void platform_mutex_unlock(platform_mutex_t* m) {
    ReleaseSRWLockExclusive(m);
}

static inline void platform_mutex_destroy(platform_mutex_t* m) {
}

static inline void platform_cond_init(platform_cond_t* c) {
    InitializeSRWLock(&c->lock);
    InitializeConditionVariable(&c->cv);
}

static inline void platform_cond_signal(platform_cond_t* c) {
    WakeConditionVariable(&c->cv);
}

static inline void platform_cond_wait(platform_cond_t* c, platform_mutex_t* m) {
    SleepConditionVariableSRW(&c->cv, m, INFINITE, 0);
}

static inline void platform_cond_destroy(platform_cond_t* c) {
}

static inline void platform_barrier_init(platform_barrier_t* b, int count) {
    b->count = count;
    b->threshold = count;
    b->cycle = 0;
    b->events[0] = CreateEvent(NULL, FALSE, FALSE, NULL);
    b->events[1] = CreateEvent(NULL, FALSE, FALSE, NULL);
    InitializeSRWLock(&b->lock);
}

static inline void platform_barrier_wait(platform_barrier_t* b) {
    int cycle;
    AcquireSRWLockExclusive(&b->lock);
    InterlockedDecrement(&b->count);
    if (b->count > 0) {
        ReleaseSRWLockExclusive(&b->lock);
        WaitForSingleObject(b->events[b->cycle % 2], INFINITE);
    } else {
        ReleaseSRWLockExclusive(&b->lock);
        SetEvent(b->events[b->cycle % 2]);
        WaitForSingleObject(b->events[(b->cycle + 1) % 2], INFINITE);
        AcquireSRWLockExclusive(&b->lock);
        b->count = b->threshold;
        cycle = b->cycle;
        b->cycle++;
        ReleaseSRWLockExclusive(&b->lock);
        SetEvent(b->events[(cycle + 1) % 2]);
    }
}

static inline void platform_barrier_destroy(platform_barrier_t* b) {
    CloseHandle(b->events[0]);
    CloseHandle(b->events[1]);
}

static inline platform_thread_t platform_create_thread(void* (*fn)(void*), void* arg) {
    return (platform_thread_t)_beginthreadex(NULL, 0, (unsigned int(__stdcall *)(void *))fn, arg, 0, NULL);
}

static inline void platform_join_thread(platform_thread_t t) {
    WaitForSingleObject((HANDLE)t, INFINITE);
    CloseHandle((HANDLE)t);
}

static inline void platform_sleep_ns(uint64_t ns) {
    Sleep((DWORD)(ns / 1000000));
}

#else

#include <pthread.h>
#include <time.h>

typedef pthread_t platform_thread_t;
typedef pthread_mutex_t platform_mutex_t;
typedef pthread_cond_t platform_cond_t;
typedef pthread_barrier_t platform_barrier_t;

static inline void platform_mutex_init(platform_mutex_t* m) {
    pthread_mutex_init(m, NULL);
}

static inline void platform_mutex_lock(platform_mutex_t* m) {
    pthread_mutex_lock(m);
}

static inline void platform_mutex_unlock(platform_mutex_t* m) {
    pthread_mutex_unlock(m);
}

static inline void platform_mutex_destroy(platform_mutex_t* m) {
    pthread_mutex_destroy(m);
}

static inline void platform_cond_init(platform_cond_t* c) {
    pthread_cond_init(c, NULL);
}

static inline void platform_cond_signal(platform_cond_t* c) {
    pthread_cond_signal(c);
}

static inline void platform_cond_wait(platform_cond_t* c, platform_mutex_t* m) {
    pthread_cond_wait(c, m);
}

static inline void platform_cond_destroy(platform_cond_t* c) {
    pthread_cond_destroy(c);
}

static inline void platform_barrier_init(platform_barrier_t* b, int count) {
    pthread_barrier_init(b, NULL, count);
}

static inline void platform_barrier_wait(platform_barrier_t* b) {
    pthread_barrier_wait(b);
}

static inline void platform_barrier_destroy(platform_barrier_t* b) {
    pthread_barrier_destroy(b);
}

static inline platform_thread_t platform_create_thread(void* (*fn)(void*), void* arg) {
    pthread_t t;
    pthread_create(&t, NULL, fn, arg);
    return t;
}

static inline void platform_join_thread(platform_thread_t t) {
    pthread_join(t, NULL);
}

static inline void platform_sleep_ns(uint64_t ns) {
    struct timespec ts;
    ts.tv_sec = ns / 1000000000;
    ts.tv_nsec = ns % 1000000000;
    nanosleep(&ts, NULL);
}

#endif
