#pragma once
#include "core/uid.h"
#include "field/field.h"
#include "field/field_glfw.h"
#include "modules/modules.h"
#include "scheme.h"
#include "core/core.h"
#include <stdint.h>
#include <stdio.h>

void core_bind_module(Node* node, core_node* module) {
    for(uint32_t i = 0; i < module->descriptor->cc; ++i) {
        auto uid = core_encode_uid(module->type, node->uid, F_CT_CONTROL, i);
        auto entity = ff_find_entity_by_id(node->parent, uid);
        if(entity)
            module->ccv[i] = &entity->value[0];
    }

    for(uint32_t i = 0; i < module->descriptor->ic; ++i) {
        auto uid = core_encode_uid(module->type, node->uid, F_CT_INPUT, i);
        auto entity = ff_find_entity_by_id(node->parent, uid);
        if(entity)
            module->icv[i] = entity->input;
    }

    for(uint32_t i = 0; i < module->descriptor->oc; ++i) {
        auto uid = core_encode_uid(module->type, node->uid, F_CT_OUTPUT, i);
        auto entity = ff_find_entity_by_id(node->parent, uid);
        if(entity) {
            entity->output = &module->ocv[i];
        }
    }
}
