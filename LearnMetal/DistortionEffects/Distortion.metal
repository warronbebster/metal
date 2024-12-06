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

// Metal Shading Language function for sine path calculation
float2 calculate_sine_path(float time, float angle)
{
    // Base sine path calculation
    float x = time;
    float y = sin(time);
    
    // 2D rotation matrix transformation
    float rotated_x = x * cos(angle) - y * sin(angle);
    float rotated_y = x * sin(angle) + y * cos(angle);
    
    return float2(rotated_x, rotated_y);
}

float2 calculate_spiral_path(float time, float angle)
{
    // Spiral parameters
    float a = 2.0;  // Controls how tightly wound the spiral is
    float growth = 0.2;  // Controls how quickly the spiral grows
    
    // Parametric equations for spiral
    // r = a + b*theta where theta increases with time
    float theta = time * a;  // Multiply by 2.0 to make it wind faster
    float radius = growth * theta;
    
    // Convert polar coordinates (r,theta) to Cartesian (x,y)
    float x = radius * cos(theta);
    float y = radius * sin(theta);
    
    // 2D rotation matrix transformation (if you want to rotate the entire spiral)
    float rotated_x = x * cos(angle) - y * sin(angle);
    float rotated_y = x * sin(angle) + y * cos(angle);
    
    return float2(rotated_x, rotated_y);
}

float calculate_angle(float x, float y)
{
    // atan2 returns angle in radians
    // Important: atan2(y, x) - note the order of arguments!
    float angle = atan2(y, x);
    
    return angle;
}


float noise2(float2 st) {

    float2 i = floor(st);
    float2 f = fract(st);

    float a = random2(i);
    float b = random2(i + float2(1.0, 0.0));
    float c = random2(i + float2(0.0, 1.0));
    float d = random2(i + float2(1.0, 1.0));

    float2 u = f*f*(3.0-2.0*f);

    return mix(a, b, u.x)
        + (c - a) * u.y * (1.0 - u.x)
        + (d - b) * u.x * u.y;
}


// Helper function to generate 2D noise
float noise2d(float x, float y) {
    // Simple 2D noise function - returns a value between -1 and 1
    // Uses multiple sine waves to create more organic movement
    float value = sin(x * 1.5) * cos(y * 1.5) * 0.5;
    value += sin(x * 3.7 + y * 2.3) * 0.25;
    value += sin(y * 4.1 - x * 1.7) * 0.25;
    return value;
}



[[ stitchable ]]
float2 distortionFadeOut(float2 position, float time) {

    // this is measured against the bounding box of the element I think
    float2 center = float2(80, -50); // Assuming screen center
    float2 directionFromCenter = normalize(position - center);  // Get direction vector pointing away from center


    // this starts quick then goes to 0
    // float logTime = log(abs(time) + 1);
    float logTime = -(pow(10, -sqrt(abs(time / 2.0))) - 1);

    // Calculate angle in radians based on position
    float angle = calculate_angle(-directionFromCenter.x, -directionFromCenter.y);
    float intensifiedAngle = angle * 3.0; // or 3.0, 4.0 for more intensity
    float noise = noise2(position);
    float position_rand = 0.2 / noise;

    // Calculate sine path displacement
    float2 sinePath = calculate_sine_path(logTime, intensifiedAngle);
    float2 displacedPos = position + (noise2d(position.x, position.y) * logTime) + (sinePath * intensifiedAngle);

    return displacedPos;
}


[[ stitchable ]]
float2 distortionFadeIn(float2 position, float time) {


    // this is measured against the bounding box of the element I think
    float2 center = float2(80, -50); // Assuming screen center
    float2 directionFromCenter = normalize(position - center);  // Get direction vector pointing away from center

    // this starts slow then accelerates
    float logTime = pow(10, -sqrt(abs(time / 2.0)));
    // float logTime = max(0.0, -log(abs(time) + 1) + 1);

    // Calculate angle in radians based on position
    float angle = calculate_angle(-directionFromCenter.x, -directionFromCenter.y);
    float intensifiedAngle = angle * 3.0; // or 3.0, 4.0 for more intensity
    float noise = noise2(position);
    float position_rand = 2.8 / noise;

    // Calculate sine path displacement
    float2 sinePath = calculate_sine_path(logTime * 2.0, intensifiedAngle);
    float2 displacedPos = position + (noise2d(position.x, position.y) * logTime) + (sinePath * intensifiedAngle);

    return displacedPos;
}

[[ stitchable ]]
float2 distortionContinuous(float2 position, float time) {

    
    // this is measured against the bounding box of the element I think
    float noise = noise2(position);
    float noiseIndex = (noise + 1.0) * 5.0;

    // Modulo the time to create a repeating cycle
    float cycleTime = fmod(abs(time), noiseIndex);
    // float cycleTime = pow(10, -sqrt(abs(cycleTime / 2.0)));


    float centerX = cycleTime * 5.0;
    float centerY = -50.0;
    float2 center = float2(centerX, centerY);
    float2 directionFromCenter = normalize(position - center);  // Get direction vector pointing away from center
    // Return original position if noise is positive
    if (noise > 0.4) {
        return position;
    }
    




    
    // Calculate angle in radians based on position
    float angle = calculate_angle(-directionFromCenter.x, -directionFromCenter.y);
    float intensifiedAngle = angle * 3.0;


    // Calculate sine path displacement
    float2 sinePath = calculate_sine_path(cycleTime, intensifiedAngle);
    
    // Add a smooth transition near the cycle boundary
    // float transitionWindow = 0.1; // Width of the transition window
    // float transitionFactor = smoothstep(cycleDuration - transitionWindow, cycleDuration, cycleTime);
    
    // Blend between current position and displaced position based on transition
    // float2 displacedPos = position + (noise2d(position.x, position.y) * time) + (sinePath * intensifiedAngle);
    // return mix(displacedPos, position, transitionFactor);

    // Calculate sine path displacement
    // float2 displacedPos = position + (noise2d(position.x, position.y) * logTime) + (sinePath * intensifiedAngle);
    float2 displacedPos = position + (sinePath * intensifiedAngle);

    return displacedPos;
}




[[ stitchable ]]
half4 hidePixels(
    float2 position,
    half4 color,
    float time
) {
    float logTime = log(abs(time) + 1) ;
    // float logTime = -(pow(10, -sqrt(abs(time))) - 1);
    
    // if (position.x + position.y > abs(time * 100.0)) {
    //     return color;
    // }
    // float timeThreshold = (abs(time) / 10) - 1.0;
    float timeThreshold = logTime;

    // if (noise2d(position.x, position.y) > timeThreshold) {
    // if (noise2(position) > timeThreshold) {
    if (random2(position) > timeThreshold) {
        return color;
    }



    return half4(color.rgb, 0.0);

}


[[ stitchable ]]
half4 showPixels(
    float2 position,
    half4 color,
    float time
) {
    float logTime = log(abs(time) + 1) * 0.8;
    float timeThreshold = logTime;

    // Show pixels over time by inverting the condition
    if (random2(position) <= timeThreshold) {
        return color;
    }

    return half4(color.rgb, 0.0);
}

