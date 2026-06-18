#include "field/field.h"
#include "field/field_glfw.h"
#include <stdint.h>
#include <stdio.h>
#include <time.h>
#include <signal.h>
#include <stdbool.h>
#include <unistd.h>
#include "scheme.h"
#define QOI_IMPLEMENTATION
#include "qoi.h"

#define WIDTH  1280
#define HEIGHT 720

void timer_callback(union sigval) 
{
    pthread_cond_signal(&_repaint_condition);
    //printf("\n[TIMER EXPIRED] 3 seconds passed in the background!\n");
}

static void slider_call(sector* slider, sector* tbox)
{
    char *text = tbox->data;
    float val = slider->value[CP_COARSE] + slider->value[CP_FINE];

    snprintf(text, 16, "%.3f", val);
    tbox->repaint = true;

    //printf("Slider callback\n");
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


    if (timer_create(CLOCK_REALTIME, &sev, &timer_id) == -1) 
    {
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
    /* Initialize GUI context */
    field context;
    initField(&context, 0, 0, WIDTH, HEIGHT, 36, ROOT);
    auto tb = createSector(&context, nullptr, ST_TEXTBOX, 100, 100, 100, 100, TRANSPARENT);

    set_text_data(tb, "Hello");

    printf("[MAIN] initField\n");

    s7_scheme* s7 = s7_init();
    bind_gui_primitives(s7);

    sector_descriptor* sd = (sector_descriptor*)s7_c_pointer(s7_eval_c_string(s7, init_scm));
    printf("Sector %u type=%d bounds=(%u,%u,%u,%u)\n",
           sd->id, sd->type,
           sd->bounds.l, sd->bounds.t, sd->bounds.w, sd->bounds.h);

    field_loop(&context);

    return 0;
}
