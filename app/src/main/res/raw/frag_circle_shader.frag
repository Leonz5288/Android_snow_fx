#version 310 es

precision highp float;

layout (location = 0) in vec2 texCoordOut;

layout (location = 0) out vec4 fragmentColor;

uniform sampler2D image;

void main() {
    fragmentColor = texture(image, texCoordOut);
}
