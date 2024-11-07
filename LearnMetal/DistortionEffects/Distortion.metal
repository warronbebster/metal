//
//  Distortion.metal
//  LearnMetal
//
//  Created by Jacob Bartlett on 06/11/2023.
//

#include <metal_stdlib>
using namespace metal;

float random2(float2 position) {
    return fract(sin(dot(position, float2(12.9898, 78.233))) * 43758.5453123);
}

[[ stitchable ]]
float2 distortion(float2 position) {
    return float2(position.x * 2, position.y);
}

// this is just a position shader. You can layer other shaders (e.g. color) below them to affect opacity
[[ stitchable ]]
float2 wiggly(float2 position, float time) {
    float2 center = float2(150, 100); // Assuming screen center
    float2 toCenter = position - center;
    float2 direction = normalize(toCenter);
    float distance = length(toCenter);
    
    // Add perlin-like noise to direction
    float noise = random2(position);
    float2 noiseDir = float2(cos(noise * 6.28), sin(noise * 6.28));
    
    // Blend original direction with noise
    direction = normalize(direction + (noiseDir * 0.1));
    
    float displacement = time * 10;
    
    return position + direction * displacement;
}
