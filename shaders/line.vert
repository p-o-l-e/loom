#version 450

layout(location = 0) in vec3 aPos;   // xy = 0-1 normalized, Y-up; z = across-line UV (0..1)

layout(push_constant) uniform PushConstants {
    vec4 uColor;    // rgb; a is the uniform alpha for solid lines
    vec4 uFade;     // x = alpha at first point, y = per-point step, z = AA width
} pc;

layout(location = 0) out vec4 vColor;
layout(location = 1) out float vU;
layout(location = 2) out float vAAWidth;

void main() {
    // Map 0-1 (Y-up) to clip space (-1..1, Y-up)
    // Vulkan viewport will have negative height to flip Y, so Y-up in
    // normalized coords maps correctly to screen Y-down.
    vec2 clip = vec2(aPos.x * 2.0 - 1.0, aPos.y * 2.0 - 1.0);
    gl_Position = vec4(clip, 0.0, 1.0);
    // Linear opacity ramp along the polyline (oscillograph CRT fade:
    // tail 0%, head 100%). Each input point generates two vertices
    // (left/right edge), so the point index is gl_VertexIndex / 2.
    float a = pc.uFade.x + float(gl_VertexIndex / 2) * pc.uFade.y;
    vColor = vec4(pc.uColor.rgb, a);
    vU = aPos.z;
    // Fixed AA width — avoids fwidth() discontinuities at triangle-strip
    // joints where the two sharing triangles have different derivatives.
    vAAWidth = pc.uFade.z;
}
