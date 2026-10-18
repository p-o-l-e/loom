#pragma once 
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include "node.h"

typedef struct core_vco core_vco;

static const core_descriptor core_vco_descriptor = { .cc = 9, .ic = 3, .oc = 2 };

struct core_vco {
    enum {
        CV_C_COARSE = 0,
        CV_C_FINE,
        CV_C_PWM,
        CV_C_FM,
        CV_C_AM,
        CV_C_AMP,
        CV_C_SW_SINE,
        CV_C_SW_SAW,
        CV_C_SW_SQUARE
    } CTL;
    enum {
        CV_I_PWM = 0,
        CV_I_FM,
        CV_I_AM
    } IN;
    enum {
        CV_O_X      = 0,
        CV_O_Y
    } OUT;
    float phase;
};

void core_vco_process(const core_node* node) {
    auto vco = (core_vco*)node->data;

    /* Frequency: coarse * fine, plus linear FM. The FM knob is a depth control
       over the FM input; 100 matches the coarse range, so full-depth FM sweeps
       one coarse range. Unconnected inputs read as fuse (0). */
    float freq = *node->ccv[CV_C_COARSE] * *node->ccv[CV_C_FINE]
               + *node->ccv[CV_C_FM] * core_node_input(node, CV_I_FM) * 100.0f;

    /* FM can drive the frequency negative, so the phase wrap is two-sided. */
    vco->phase += freq * 0.001f;
    if(vco->phase > pi) vco->phase -= tao;
    else if(vco->phase < -pi) vco->phase += tao;

    /* Amplitude: AMP knob with tremolo from the AM depth knob and AM input. */
    float amp = *node->ccv[CV_C_AMP] * (1.0f + *node->ccv[CV_C_AM] * core_node_input(node, CV_I_AM));

    /* Pulse width: PWM knob plus PWM input, mapped from -1..1 to duty 0..1. */
    float duty = 0.5f + 0.5f * (*node->ccv[CV_C_PWM] + core_node_input(node, CV_I_PWM));
    if(duty < 0.0f) duty = 0.0f;
    else if(duty > 1.0f) duty = 1.0f;

    /* Waveform select: radio group, exactly one switch engaged; sine is the default. */
    float wave;
    if(*node->ccv[CV_C_SW_SAW] > 0.5f) {
        wave = vco->phase * (1.0f / pi);
    } else if(*node->ccv[CV_C_SW_SQUARE] > 0.5f) {
        wave = vco->phase < duty * tao - pi ? 1.0f : -1.0f;
    } else {
        wave = sinf(vco->phase);
    }

    /* X is the time base (phase ramp), Y is the waveform — an oscilloscope trace
       when wired to a CRT's X/Y inputs. */
    node->ocv[CV_O_X] = vco->phase * (1.0f / pi);
    node->ocv[CV_O_Y] = wave * amp;
}
