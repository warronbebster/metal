//
//  Extra.metal
//  LearnMetal
//
//  Created by Jacob Bartlett on 06/11/2023.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 randomNoise(
    float2 position,
    half4 color,
    float time
) {
    float value = fract(sin(dot(position + time, float2(12.9898, 78.233))) * 43758.5453);
    return half4(value, value, value, 1) * color.a;
}

float random(float2 position) {
    return fract(sin(dot(position, float2(12.9898, 78.233))) * 43758.5453123);
}

float noise(float2 st, float time) {

    float2 i = floor(st);
    float2 f = fract(st);
    int speed = 10;

    float2 offset = float2(time / speed);
    i += offset;

    float a = random(i);
    float b = random(i + float2(1.0, 0.0));
    float c = random(i + float2(0.0, 1.0));
    float d = random(i + float2(1.0, 1.0));

    float2 u = f*f*(3.0-2.0*f);

    return mix(a, b, u.x)
        + (c - a) * u.y * (1.0 - u.x)
        + (d - b) * u.x * u.y;
}

[[ stitchable ]]
half4 perlinNoise(
    float2 position,
    half4 color,
    float2 size,
    float time
) {
    float2 st = position / size;
    float2 pos = float2(st * 10);
    float n = noise(pos, time);
    return half4(half3(n), 1.0);
}


float turbulence(float2 st, float time) {
    float value = 0.0;
    float2 shift = float2(10.0);
    float amplitude = 1.0;
    
    // Add noise at different frequencies and amplitudes
    for (int i = 0; i < 4; i++) {
        value += amplitude * noise(st, time);
        st *= 1.5; // Changed from 2.0 to 1.5 to make the change slower
        shift *= 1.5; // Changed from 2.0 to 1.5 to make the change slower
        amplitude *= 0.75; // Changed from 0.5 to 0.75 to make the change slower
    }
    
    return value;
}

[[ stitchable ]]
half4 turbulenceNoise(
    float2 position,
    half4 color,
    float2 size,
    float time
) {
    float2 st = position / size;
    float2 pos = float2(st * 8);
    float t = turbulence(pos, time);
    return half4(half3(t), 1.0) * color.a;
}
