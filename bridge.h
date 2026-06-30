#pragma once
#include "core/uid.h"
#include "field/field.h"
#include "field/field_glfw.h"
#include "modules/modules.h"
#include "scheme.h"
#include "core/core.h"
#include <stdint.h>

void core_bind_module(Node* node, core_node* module) {
    // for(uint32_t i = 0; i < module->descriptor->cc; ++i) {
    //     auto uid = core_encode_uid(module->type, module->uid, , uint8_t)
    //     auto entity = ff_find_entity_by_id(node->parent, 0); 
    //     auto value = &node->at[0].value[0];
    //     module->ccv[i] = value;
    // }

}
