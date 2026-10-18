#pragma once 
#include <stdint.h>
#include "node.h"

typedef struct core_split core_split;

static const core_descriptor core_split_descriptor = { .cc = 2, .ic = 3, .oc = 2 };

/* Stateless: no per-node state, the struct only groups the index enums. */
struct core_split {
    enum {
        CS_C_INV_A = 0,
        CS_C_INV_B
    } CTL;
    enum {
        CS_I_IN = 0,    ///< icv[0]: signal to split
        CS_I_CTL_A,     ///< icv[1]: negative inverts output A
        CS_I_CTL_B      ///< icv[2]: negative inverts output B
    } IN;
    enum {
        CS_O_A = 0,
        CS_O_B
    } OUT;
};

void core_split_process(const core_node* node) {
    /* Fan-out with per-output polarity. Each output's sign flips when its
       control input is negative and when its INV checkbox is engaged; the
       two compose multiplicatively (both active = no inversion). Unconnected
       inputs read as 0, so an unconnected control never inverts. */
    float const in    = core_node_input(node, CS_I_IN);
    float const ctl_a = core_node_input(node, CS_I_CTL_A);
    float const ctl_b = core_node_input(node, CS_I_CTL_B);

    bool const inv_a = (*node->ccv[CS_C_INV_A] > 0.5f) != (ctl_a < 0.0f);
    bool const inv_b = (*node->ccv[CS_C_INV_B] > 0.5f) != (ctl_b < 0.0f);

    node->ocv[CS_O_A] = inv_a ? -in : in;
    node->ocv[CS_O_B] = inv_b ? -in : in;
}
