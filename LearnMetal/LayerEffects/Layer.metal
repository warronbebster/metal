//
//  Layer.metal
//  LearnMetal
//
//  Created by Jacob Bartlett on 06/11/2023.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 pixellate(
    float2 position,
    SwiftUI::Layer layer,
    float size,
    float time
) {
    float sample_x = sin(time) + size * round(position.x / size);
    float sample_y = cos(time) + size * round(position.y / size);
    return layer.sample(float2(sample_x, sample_y));
}

[[ stitchable ]]
half4 dissolve(
    float2 position,
    SwiftUI::Layer layer,
    float time
) {
    // Sample original color at current position
    half4 originalColor = layer.sample(position);
    
    // Center point
    float2 center = float2(150.0, 250.0);
    
    // Calculate vector from center to current position
    float2 toPosition = position - center;
    float dist = length(toPosition);
    // Generate noise based on position and time
    float2 noisePos = position * 0.01;
    float noise = fract(sin(dot(noisePos + float2(time * 0.5), float2(12.9898, 78.233))) * 43758.5453);
    
    // Add turbulence by layering noise at different frequencies
    float turbulence = noise;
    turbulence += fract(sin(dot(noisePos * 2.0 + float2(time), float2(12.9898, 78.233))) * 43758.5453) * 0.5;
    
    // Use turbulence to modify the displacement direction
    float2 turbulentDir = float2(
        cos(turbulence),
        sin(turbulence)
    );
    
    // Combine original direction with turbulent direction
    float2 direction = normalize(toPosition) + turbulentDir;
    
    // Scale displacement based on distance from center and time
    float displacement = time * 20.0 * (1.0 + turbulence);
    float2 newPosition = position + direction * displacement;
    
    // Fade out based on displacement
    float fade = 1.0 - smoothstep(0.0, 100.0, displacement);
    
    return originalColor * half4(1.0, 1.0, 1.0, fade);
}


