#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 lightPosition; // The position of the light (player position)
uniform vec2 resolution;    // Screen resolution
uniform float lightRadius;  // Radius of the light
uniform vec4 lightColor;    // Color of the light

varying vec2 vtexcoord;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    // Normalize screen coordinates
    vec2 uv = screen_coords / resolution;
    vec2 lightUV = lightPosition / resolution;

    // Calculate the distance from the light source
    float dist = distance(uv, lightUV);

    // Create a radial gradient for the light
    float intensity = 3.0 - smoothstep(lightRadius * 0.0, lightRadius, dist);

    // Apply the light color and intensity
    vec4 lightEffect = vec4(lightColor.rgb * intensity, intensity);

    // Combine the light effect with the texture color
    vec4 texColor = Texel(texture, texture_coords);
    return mix(texColor, lightEffect, intensity) * color;
}