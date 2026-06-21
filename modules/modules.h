#pragma once
#include "../s7/s7.h"

typedef enum {
    MT_FUSE,
    MT_VCO,

    MT_LIMIT

} ModuleType;

void bind_module_definitions(s7_scheme *s7) {
    s7_define_variable(s7, "MT_FUSE", s7_make_integer(s7, MT_FUSE));
    s7_define_variable(s7, "MT_VCO", s7_make_integer(s7, MT_VCO));
    s7_define_variable(s7, "MT_LIMIT", s7_make_integer(s7, MT_LIMIT));
}
