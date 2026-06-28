#include "field/field.h"
#include "field/field_glfw.h"
#include <stdint.h>
#include <stdio.h>
#include <time.h>
#include <signal.h>
#include <stdbool.h>
#include <unistd.h>
#include "modules/modules.h"
#include "scheme.h"
#define QOI_IMPLEMENTATION
#include "qoi.h"

#define WIDTH  1280
#define HEIGHT 720

void timer_callback(union sigval) {
    pthread_cond_signal(&_repaint_condition);
}

int main(int argc, char** argv)
{
    timer_t timer_id;
    struct sigevent sev;
    struct itimerspec its;

    sev = (struct sigevent){0};
    its = (struct itimerspec){0};

    sev.sigev_notify = SIGEV_THREAD;
    sev.sigev_notify_function = timer_callback;
    sev.sigev_value.sival_ptr = &timer_id;

    if (timer_create(CLOCK_REALTIME, &sev, &timer_id) == -1) {
        perror("timer_create");
        return 1;
    }

    its.it_value.tv_sec     = 1;
    its.it_value.tv_nsec    = 0;
    its.it_interval.tv_sec  = 1;
    its.it_interval.tv_nsec = 0;

    if (timer_settime(timer_id, 0, &its, NULL) == -1) {
        perror("timer_settime");
        timer_delete(timer_id);
        return 1;
    }

    Field* context = ffCreateField(0, 0, WIDTH, HEIGHT, 4, ROOT);

    printf("[MAIN] initField\n");

    s7_scheme* s7 = s7_init();
    bindGuiConstants(s7);
    bindModuleDefinitions(s7);
    s7_load_embedded(s7, init_scm, "init_scm");
    s7_load_embedded(s7, layout_scm, "layout_scm");
    s7_load_embedded(s7, vco_scm, "vco_scm");
    s7_load_embedded(s7, generator_scm, "generator_scm");
    s7_load_embedded(s7, crt_scm, "crt_scm");

    auto vco = load_module(s7, context, "vco");
    auto gen = load_module(s7, context, "generator");
    auto crt = load_module(s7, context, "crt");
    ffPlaceNode(context, vco, 200, 0);
    ffPlaceNode(context, gen, 500, 0);
    ffPlaceNode(context, crt, 500, 300);

    field_loop(context);
    return 0;
}
