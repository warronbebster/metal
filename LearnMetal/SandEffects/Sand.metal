#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

float hash(float2 p) {
    return fract(sin(dot(p, float2(12.9898, 78.233))) * 43758.5453);
}

[[ stitchable ]] half4 sandSimulation(
    float2 position,
    SwiftUI::Layer layer,
    float2 resolution,
    float time
) {
    half4 originalColor = layer.sample(position);
    
    // Check if current pixel is part of the content (not transparent)
    if (originalColor.a < 0.1) {
        return half4(0.0);  // Return transparent for empty spaces
    }
    
    // Calculate potential new position based on time
    float fallDistance = time;  // Control fall speed
    float2 newPos = position;
    
    // Try positions from current to maximum fall distance
    for (float y = 0; y <= fallDistance; y += 1.0) {
        float2 checkPos = position + float2(0.0, y);
        half4 checkColor = layer.sample(checkPos);
        
        if (checkColor.a < 0.1) {  // Found an empty spot
            newPos = checkPos;
            
            // Try diagonal movement if blocked
            float2 diagCheckPos = newPos + float2(hash(position + time) > 0.5 ? 1.0 : -1.0, 1.0);
            half4 diagColor = layer.sample(diagCheckPos);
            
            if (diagColor.a < 0.1) {
                newPos = diagCheckPos;
            }
        } else {
            break;  // Stop when we hit something
        }
    }
    
    // If we moved, show sand at new position
    if (newPos.y > position.y) {
        return half4(1.0, 0.8, 0.6, 1.0);  // Sand color
    }
    
    return originalColor;  // Stay in place if we couldn't move
}