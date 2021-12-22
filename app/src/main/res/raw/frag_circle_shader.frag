#version 310 es

precision highp float;

layout (location = 0) in vec2 out_v2Position;

layout (location = 0) out vec4 fragmentColor;

layout (std140, binding = 0) uniform shader_data {
    vec2 resolution;
    vec3 color;
    float radius;
};

float circle(in vec2 st, in float radius) {
    radius = radius*radius;
    vec2 dist = vec2(gl_FragCoord.x/resolution.x/2.0, gl_FragCoord.y/resolution.y) - st;
    return 1.0 - smoothstep(radius - (radius * 0.1), radius + (radius * 0.1), dot(dist, dist) * 4.0);
}

void main() {
    if (circle(out_v2Position, radius/resolution.x) < 0.5) {
        discard;
    }
    fragmentColor = vec4(color, 1.0);
}
