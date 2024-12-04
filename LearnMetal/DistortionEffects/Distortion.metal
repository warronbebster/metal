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
    float theta = time * 2.0;  // Multiply by 2.0 to make it wind faster
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

// float2 displace(float2 position, float2 center, float time) {
//     // Calculate vector from center to position
//     float2 toCenter = position - center;
    
//     // Calculate base direction from center
//     float2 baseDirection = normalize(toCenter);
    
//     // Get persistent noise value based on original position only
//     // Scale position down for smoother variation between neighboring pixels
//     // this returns a value from -1 to 1
//     float noiseValue = noise2(position) * 2.0 - 1.0;
    
//     // Create a subtle directional offset
//     // Convert noise to a small angle variation (-0.2 to 0.2 radians)
//     // float angle = (noiseValue - 0.5);
//     // float2 noiseDirection = float2(
//     //     cos(angle) * baseDirection.x - sin(angle) * baseDirection.y,
//     //     sin(angle) * baseDirection.x + cos(angle) * baseDirection.y
//     // );
    
//     // Scale displacement with time using smooth log growth
//     float displacement = (log(abs(time) + 1) * 40) * noiseValue;
//     // float displacement = (abs(time) + 1) * noiseValue;
//     // float displacement = (abs(time) + 1);

//     float2 displacedPos = position - baseDirection * displacement;

//     // float noiseOnDestination = noise2(displacedPos, 0);
    
//     // float2 finalPos = displacedPos + noiseDirection;
    
//     // Apply the displacement in the noise-modified direction
//     return displacedPos;
// }

// this is just a position shader. You can layer other shaders (e.g. color) below them to affect opacity
// [[ stitchable ]]
// float2 wiggly(float2 position, float time) {
//     float2 center = float2(80, 150); // Assuming screen center
//     float2 toCenter = position - center;
//     float2 direction = normalize(toCenter);
//     // float distance = length(toCenter);
    
//     // Add perlin-like noise to direction
//     // this just adds random noise in a particular direction, but doesn't displace consistently
//     float noiseAmount = noise2(position);
//     float2 noiseDir = float2(cos(noiseAmount * 6.28), sin(noiseAmount * 6.28));
    
//     // Blend original direction with noise
//     direction = -normalize(direction );
//     int displacementSpeed = 5;
//     int displacementAmount = 20;

//     float logTime = log(abs(time) + 1) * displacementSpeed;
    
//     // ok so dividing the displacement by time reverses the spread
//     // float displacement =  log(time) + 1;
//    float displacement = max(logTime, 0.0) * displacementAmount;
//     // exponential decay: this starts quick and then falls into place
//     //  float displacement = 100 * pow(2, time);
    
//     // return position + direction * displacement;
//     return displace(position, center, time);
// }

// [[ stitchable ]] 
// float2 sandy(float2 position, float time) {
//     float2 center = float2(80, 150); // Assuming screen center
//     float2 directionFromCenter = normalize(position - center);  // Get direction vector pointing away from center
    
//     // Calculate fall distance based on time
//     float distance = time;
//     float frequency = 0.3;
//     float driftStrength = 3.5;  // Adjust this to control how strongly particles drift away
    
//     float2 newPos = position;
    
//     // Add noise for organic movement
//     float noiseX = noise2d(position.x * frequency, time * frequency);
//     float noiseY = noise2d(position.y * frequency, (time + 100) * frequency);
//     newPos.x += noiseX * distance;
//     newPos.y += noiseY * distance;
    
//     // Add directional drift away from center
//     newPos += abs(directionFromCenter * distance * driftStrength);
    
//     return newPos;
// }


[[ stitchable ]]
float2 distortion(float2 position, float time) {
        // some pixels stay in place
    // if (random2(position) > 0.8) {
    //     return position;
    // }

    // this is measured against the bounding box of the element I think
    float2 center = float2(100, -50); // Assuming screen center
    float2 directionFromCenter = normalize(position - center);  // Get direction vector pointing away from center


    // this starts quick then goes to 0
    // float logTime = log(abs(time) + 1);
    float logTime = -(pow(10, -sqrt(abs(time))) - 1);

    // Calculate angle in radians based on position
    float angle = calculate_angle(-directionFromCenter.x, -directionFromCenter.y);
    float intensifiedAngle = angle * 3.0; // or 3.0, 4.0 for more intensity
    float noise = noise2(position);
    float position_rand = 1.0 / noise;

    // Calculate sine path displacement
    float2 sinePath = calculate_sine_path(logTime, intensifiedAngle);
    float2 displacedPos = position + (position_rand * (sinePath * intensifiedAngle));

    return displacedPos;
}

[[ stitchable ]]
half4 hidePixels(
    float2 position,
    half4 color,
    float time
) {
    float logTime = log(abs(time) + 1);
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
