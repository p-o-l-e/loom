#version 450

layout(location = 0) in vec4 vColor;
layout(location = 1) in float vU;
layout(location = 2) in float vAAWidth;
layout(location = 0) out vec4 FragColor;

void main() {
    // Procedural anti-aliasing: vU is 0..1 across the line width.
    // d = 0 at centre, 1 at edge. Fixed AA width (from push constant)
    // gives a constant ~1px smoothstep transition — no fwidth()
    // discontinuities at triangle-strip joints.
    float d = abs(vU - 0.5) * 2.0;
    float coverage = 1.0 - smoothstep(1.0 - vAAWidth, 1.0, d);
    // Premultiplied alpha output: rgb already multiplied by alpha.
    // Overlapping fragments at joints add up instead of double-brightening.
    float a = vColor.a * coverage;
    FragColor = vec4(vColor.rgb * a, a);
}
