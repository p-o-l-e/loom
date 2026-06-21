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

    field context;
    initField(&context, 0, 0, WIDTH, HEIGHT, 36, ROOT);

    printf("[MAIN] initField\n");

    s7_scheme* s7 = s7_init();
    bind_gui_primitives(s7);
    bind_module_definitions(s7);
    s7_load_embedded(s7, init_scm, "init_scm");
    s7_load_embedded(s7, layout_scm, "layout_scm");
    s7_load_embedded(s7, vco_scm, "vco_scm");

    s7_pointer list_obj = s7_eval_c_string(s7, "descriptors");

    if (s7_is_list(s7, list_obj)) {
        int len = s7_list_length(s7, list_obj);
        for(int i = 0; i < len; i++) {
            s7_pointer item = s7_list_ref(s7, list_obj, i);
            if(s7_is_c_pointer(item)) {
                sector_descriptor* sd = (sector_descriptor*)s7_c_pointer(item);
                printf("Descriptor %d: id=%u type=%d bounds=(%u,%u,%u,%u) output=%u\n",
                    i, sd->id, sd->type,
                    sd->bounds.l, sd->bounds.t, sd->bounds.w, sd->bounds.h, sd->output);
                    createSectorD(&context, sd);
            } 
            else {
                fprintf(stderr, "Item %d is not a C pointer!\n", i);
            }
        }
    }

    field_loop(&context);
    return 0;
}
