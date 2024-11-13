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
    
    // Debug movement attempts with more detail
    // if (originalColor.a < 0.1) {
    //     return half4(0.0, 0.0, 1.0, 0.1);  // Blue for empty space
    // }
    
    // Use floor(time) to get discrete steps of movement
    float steps = floor(abs(time) * 4.0);  // Multiply by 2.0 to move twice per second
    float random = hash(position + float2(steps));  // Add randomness based on position
    
    if (steps > 0) {
        // Try to move down by the number of steps
        float2 newPos = position - float2(0.0, steps);
        half4 checkColor = layer.sample(newPos);
        
        if (checkColor.a < 0.1) {
            // Space is empty, show movement
            return half4(0.0, 1.0, 0.0, 0.3);  // Green for movement
        } 

        // Check diagonals with randomness
        float2 leftPos = newPos + float2(-1.0, 1.0);
        float2 rightPos = newPos + float2(1.0, 1.0);
        half4 leftColor = layer.sample(leftPos);
        half4 rightColor = layer.sample(rightPos);
        
        if (leftColor.a < 0.5 && rightColor.a < 0.5) {
            // Both directions available, choose randomly
            return random > 0.5 ? originalColor : half4(1, 0, 0, 0);
        } else if (leftColor.a < 0.5) {
            return random > 0.7 ? originalColor : half4(1, 0, 0, 0);  // 30% chance to move
        } else if (rightColor.a < 0.5) {
            return random > 0.7 ? originalColor : half4(1, 0, 0, 0);  // 30% chance to move
        }
    }
    
    return originalColor;  // Stay in original position if can't move
}

[[ stitchable ]] half4 sandReceive(
    float2 position,
    SwiftUI::Layer layer,
    float2 resolution,
    float time
) {
    half4 currentColor = layer.sample(position);
    
    // If current position is not empty, no need to check for incoming sand
    if (currentColor.a > 0.2) {
        return currentColor;
    }
    
    float steps = floor(abs(time) * 4.0);
    
    // Check above positions for sand that might fall here
    float2 abovePos = position + float2(0.0, -1.0);
    float2 leftPos = position + float2(-1.0, -1.0);
    float2 rightPos = position + float2(1.0, -1.0);
    
    half4 aboveColor = layer.sample(abovePos);
    half4 leftColor = layer.sample(leftPos);
    half4 rightColor = layer.sample(rightPos);
    
    // If any position above has sand that's marked for movement (a == 0)
    if (aboveColor.a > 0.1) {
        return half4(0.8, 0.7, 0.2, 1.0);  // Sand color
    } else if (leftColor.a > 0.1) {
        return half4(0.8, 0.7, 0.2, 1.0);
    } else if (rightColor.a > 0.1) {
        return half4(0.8, 0.7, 0.2, 1.0);
    }
    
    return currentColor;
}