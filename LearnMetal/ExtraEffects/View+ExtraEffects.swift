//
//  View+ExtraEffects.swift
//  LearnMetal
//
//  Created by Jacob Bartlett on 06/11/2023.
//

import SwiftUI

extension View {

    func randomNoiseShader() -> some View {
        modifier(RandomNoiseShader())
    }
    
//    this function takes a view and applies a "modifier"
    func perlinNoiseShader() -> some View {
        modifier(PerlinNoiseShader())
    }

    func turbNoiseShader() -> some View {
        modifier(TurbNoiseShader())
    }
}

struct RandomNoiseShader: ViewModifier {
    
    let startDate = Date()
    
    func body(content: Content) -> some View {
        TimelineView(.animation) { _ in
            content
                .colorEffect(
                    ShaderLibrary.randomNoise(
                        .float(startDate.timeIntervalSinceNow)
                    )
                )
        }
    }
}

struct PerlinNoiseShader: ViewModifier {

    let startDate = Date()
    
    func body(content: Content) -> some View {
        TimelineView(.animation) { _ in
            content.visualEffect { content, proxy in
                content
                    .colorEffect(
                        ShaderLibrary.perlinNoise(
                            .float2(proxy.size),
                            .float(startDate.timeIntervalSinceNow)
                        )
                    )
            }
        }
    }
}


struct TurbNoiseShader: ViewModifier {

    let startDate = Date()
    
    func body(content: Content) -> some View {
        TimelineView(.animation) { _ in
            content
                .visualEffect { content, proxy in
                    content
                        .colorEffect(
                            ShaderLibrary.turbulenceNoise(
                                .float2(proxy.size),
                                .float(startDate.timeIntervalSinceNow)
                            )
                        )
                }
        }
    }
}
