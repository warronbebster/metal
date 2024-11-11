//
//  View+DistortionEffect.swift
//  LearnMetal
//
//  Created by Jacob Bartlett on 06/11/2023.
//

import SwiftUI

extension View {
    
    func distortionShader() -> some View {
        modifier(DistortionShader())
    }
    
    func wigglyShader() -> some View {
        modifier(WigglyShader())
    }
    
    func sandyShader() -> some View {
        modifier(SandyShader())
    }

}

struct DistortionShader: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 100)
            .drawingGroup()
            .distortionEffect(
                ShaderLibrary.distortion(),
                maxSampleOffset: CGSize(width: 100, height: 0)
            )
    }
}

struct WigglyShader: ViewModifier {

    private let startDate = Date()

    func body(content: Content) -> some View {
        TimelineView(.animation) { _ in
            content
                .padding(.vertical, 100)
                .drawingGroup()
                .distortionEffect(
                    ShaderLibrary.wiggly(
                        .float(startDate.timeIntervalSinceNow)),
//                    warn iOS that the pixels might move
                    maxSampleOffset: CGSize(width: 100, height: 200)
                )
        }
    }
}
struct SandyShader: ViewModifier {

    private let startDate = Date()

    func body(content: Content) -> some View {
        TimelineView(.animation) { _ in
            content
                .drawingGroup()
                .distortionEffect(
                    ShaderLibrary.sandy(
                        .float(startDate.timeIntervalSinceNow)),
//                    warn iOS that the pixels might move
                    maxSampleOffset: CGSize(width: 100, height: 200)
                )
        }
    }
}
