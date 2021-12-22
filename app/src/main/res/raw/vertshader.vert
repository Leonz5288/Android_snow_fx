#version 310 es

precision highp float;

layout (location = 0) in vec2 a_v2Position;

layout (location = 1) in uint a_index;

layout (binding = 0) buffer color_palette {vec4 _color_palette[];};

layout (location = 0) out vec4 v_v4FillColor;

void main() {
    v_v4FillColor = _color_palette[a_index];
    gl_Position = vec4(a_v2Position.x*4.0 - 1.0, a_v2Position.y*2.0 - 1.0, 1, 1);
    //gl_Position = a_v4Position;
    gl_PointSize = 10.0f;
}
