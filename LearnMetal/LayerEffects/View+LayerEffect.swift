//
//  View+LayerEffect.swift
//  LearnMetal
//
//  Created by Jacob Bartlett on 06/11/2023.
//

import SwiftUI

extension View {
    
    func pixellationShader(pixelSize: Float = 8) -> some View {
        modifier(PixellationShader(pixelSize: pixelSize))
    }
    
    func dissolveShader() -> some View {
        modifier(DissolveShader())
    }
}

struct PixellationShader: ViewModifier {
    
    let pixelSize: Float
    let startDate = Date()
    
    func body(content: Content) -> some View {
        TimelineView(.animation) { _ in
            content
                .layerEffect(
                    ShaderLibrary.pixellate(
//                        pass in pixel size param and time param
                        .float(pixelSize),
                        .float(startDate.timeIntervalSinceNow)
                    ), maxSampleOffset: .zero
                )
        }
    }
}

struct DissolveShader: ViewModifier {
    
    let startDate = Date()
    
    func body(content: Content) -> some View {
        TimelineView(.animation) { _ in
            content
                .padding(50)
                .drawingGroup()
                .layerEffect(
                    ShaderLibrary.dissolve(
//                        pass in pixel size param and time param
                        .float(startDate.timeIntervalSinceNow)
                    ),  maxSampleOffset: CGSize(width: 100, height: 100)
                )
        }
    }
}



