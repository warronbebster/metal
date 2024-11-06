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
    
    // Normalize the vector and move outward based on time
    float2 direction = normalize(toPosition);
    float2 newPosition = position + direction * time;
    
    // Sample color at the new position
    half4 newColor = layer.sample(newPosition);
    
    // Only use new position if it's transparent at the destination
    float alpha = (newColor.a < 0.01) ? originalColor.a : 0.0;
   
    return originalColor * half4(1.0, 1.0, 1.0, alpha);
}


