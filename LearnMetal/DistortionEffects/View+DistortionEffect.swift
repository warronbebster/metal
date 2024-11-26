//
//  View+DistortionEffect.swift
//  LearnMetal
//
//  Created by Jacob Bartlett on 06/11/2023.
//

import SwiftUI

extension View {
    
    func distortionShader(isEnabled: Bool) -> some View {
        modifier(DistortionShader(isEnabled: isEnabled))
    }
    
    func wigglyShader() -> some View {
        modifier(WigglyShader())
    }
    
    func sandyShader() -> some View {
        modifier(SandyShader())
    }

}

struct DistortionShader: ViewModifier {
    let isEnabled: Bool
    private let startDate = Date()
    
    func body(content: Content) -> some View {
        if isEnabled {
            TimelineView(.animation) { _ in
                content
                    .drawingGroup()
                    .colorEffect(ShaderLibrary.hidePixels(
                        .float(startDate.timeIntervalSinceNow))
                    )
                    .distortionEffect(
                        ShaderLibrary.distortion(
                            .float(startDate.timeIntervalSinceNow)),
                        maxSampleOffset: CGSize(width: 100, height: 200)
                    )
            }
        } else {
            content
        }
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
                    maxSampleOffset: CGSize(width: 120, height: 200)
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
                    maxSampleOffset: CGSize(width: 240, height: 200)
                )
        }
    }
}
