#version 450

layout(location = 0) in vec2 aPos;   // 0-1 normalized, Y-up

layout(push_constant) uniform PushConstants {
    vec4 uColor;
} pc;

layout(location = 0) out vec4 vColor;

void main() {
    // Map 0-1 (Y-up) to clip space (-1..1, Y-up)
    // Vulkan viewport will have negative height to flip Y, so Y-up in
    // normalized coords maps correctly to screen Y-down.
    vec2 clip = vec2(aPos.x * 2.0 - 1.0, aPos.y * 2.0 - 1.0);
    gl_Position = vec4(clip, 0.0, 1.0);
    vColor = pc.uColor;
}
