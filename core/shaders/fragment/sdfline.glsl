#version 330 core
#define BSIZE 128
uniform vec2 samples[BSIZE];
uniform float thickness;
uniform vec4 lineColor;

float sdSegment(vec2 p, vec2 a, vec2 b) {
    vec2 pa = p - a, ba = b - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h);
}

out vec4 FragColor;

void main() {
    vec2 uv = gl_FragCoord.xy;
    float dmin = 1e6;
    for(int i = 0; i < BSIZE-1; i++) {
        dmin = min(dmin, sdSegment(uv, samples[i], samples[i+1]));
    }
    if(dmin < thickness) {
        FragColor = lineColor;
    } 
    else {
        discard;
    }
}

