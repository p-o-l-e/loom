#version 450

layout(location = 0) in vec2 vUV;
layout(location = 0) out vec4 FragColor;

layout(set = 0, binding = 0) uniform sampler2D uTex;

void main() {
    vec4 c = texture(uTex, vUV);
    // Frame data is 0xRRGGBBAA uint32_t. On little-endian, bytes in memory
    // are AA BB GG RR, so VK_FORMAT_R8G8B8A8_UNORM reads them as R=A, G=B,
    // B=G, A=R. Swizzle back: output = (texA, texB, texG, texR) = (R, G, B, A).
    FragColor = vec4(c.a, c.b, c.g, c.r);
}
