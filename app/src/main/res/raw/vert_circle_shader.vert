#version 310 es

precision highp float;

layout (location = 0) in vec2 a_v2Position;

layout (location = 0) out vec2 out_v2Position;

void main() {
    gl_Position = vec4(a_v2Position.x*4.0 - 1.0, a_v2Position.y*2.0 - 1.0, 1, 1);
    out_v2Position = a_v2Position.xy;
    gl_PointSize = 500.0f;
}
