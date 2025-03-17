#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform sampler2D tex;

varying vec4 vpos;
varying vec2 vtexcoord;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec2 uv = texture_coords;
    vec3 col = Texel(texture, uv).rgb;

    float scanline = sin(uv.y * resolution.y * 1.5 + time) * 0.1;
    col *= 1.0 - scanline;

    return vec4(col, 1.0) * color;
}