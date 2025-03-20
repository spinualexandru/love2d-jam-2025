#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform sampler2D tex;

varying vec4 vpos;
varying vec2 vtexcoord;

// Random function for noise
float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec2 uv = texture_coords;
    vec3 col = Texel(texture, uv).rgb;

    // Add scanline effect
    float scanline = sin(uv.y * resolution.y * 1.5 + time) * 0.1;
    col *= 1.0 - scanline;

    // Add horizontal glitch offset
    float glitchOffset = sin(time * 10.0 + uv.y * 50.0) * 0.005;
    uv.x += glitchOffset;

    // Add color channel separation
    float glitchStrength = step(0.98, random(vec2(time, uv.y))) * 0.02; // Random glitch trigger
    vec3 glitchCol;
    glitchCol.r = Texel(texture, uv + vec2(glitchStrength, 0.0)).r; // Red channel offset
    glitchCol.g = Texel(texture, uv).g;                             // Green channel (no offset)
    glitchCol.b = Texel(texture, uv - vec2(glitchStrength, 0.0)).b; // Blue channel offset
    col = mix(col, glitchCol, glitchStrength);

    // Add random noise
    float noise = random(uv + time) * 0.05;
    col += noise;

    return vec4(col, 1.0) * color;
}