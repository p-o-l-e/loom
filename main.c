#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include "bridge.h"
#include "core/node.h"
#define QOI_IMPLEMENTATION
#include "qoi.h"

#define WIDTH  1280
#define HEIGHT 720

int main(void)
{
    Field* context = ffCreateField(0, 0, WIDTH, HEIGHT, 7, ROOT);

    printf("[MAIN] initField\n");

    /* initScheme binds all C functions into s7 and loads the embedded
     * module definitions. Then loadPatch loads the patch layout from disk
     * — the patch constructs the rack, instantiates modules, places them,
     * wires them to core nodes, and starts the processing thread. */
    s7_scheme* s7 = s7_init();
    initScheme(s7, context);
    loadPatch(s7, context, "../patches/save.scm", wire_controls);

    /* field_loop owns the thread lifecycle: spawns the draw and event
     * threads and blocks until the window is closed (then calls exit). */
    field_loop(context);

    return 0;
}
