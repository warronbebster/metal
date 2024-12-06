//
//  View+DistortionEffect.swift
//  LearnMetal
//
//  Created by Jacob Bartlett on 06/11/2023.
//

import SwiftUI

extension View {
    func distortionFadeOutShader(isEnabled: Bool) -> some View {
        modifier(DistortionFadeOutShader(isEnabled: isEnabled))
    }

    func distortionFadeInShader(isEnabled: Bool) -> some View {
        modifier(DistortionFadeInShader(isEnabled: isEnabled))
    }

    func distortionContinuousShader(isEnabled: Bool) -> some View {
        modifier(DistortionContinuousShader(isEnabled: isEnabled))
    }
}

struct DistortionFadeOutShader: ViewModifier {
    let isEnabled: Bool
    private let startDate = Date()
    
    func body(content: Content) -> some View {
        if isEnabled {
            TimelineView(.animation) { _ in
                content
                    .drawingGroup()
                    // .background(Color(red: 243/255, green: 240/255, blue: 229/255))
                    .colorEffect(ShaderLibrary.hidePixels(
                        .float(startDate.timeIntervalSinceNow))
                    )
                    .distortionEffect(
                        ShaderLibrary.distortionFadeOut(
                            .float(startDate.timeIntervalSinceNow)),
                        maxSampleOffset: CGSize(width: 100, height: 200)
                    )
                    .compositingGroup() // Add this
                    .blendMode(.darken) // Try different blend modes
                    
            }
            
        } else {
            content
        }
    }
}

struct DistortionFadeInShader: ViewModifier {
    let isEnabled: Bool
    private let startDate = Date()
    
    func body(content: Content) -> some View {
        if isEnabled {
            TimelineView(.animation) { _ in
                content
                    .drawingGroup()
                    // .background(Color(red: 243/255, green: 240/255, blue: 229/255))
                    .colorEffect(ShaderLibrary.showPixels(
                        .float(startDate.timeIntervalSinceNow))
                    )
                    .distortionEffect(
                        ShaderLibrary.distortionFadeIn(
                            .float(startDate.timeIntervalSinceNow)),
                        maxSampleOffset: CGSize(width: 100, height: 200)
                    )
                    .compositingGroup() // Add this
                    .blendMode(.darken) // Try different blend modes
                    
            }
            
        } else {
            content
        }
    }
}

struct DistortionContinuousShader: ViewModifier {
    let isEnabled: Bool
    private let startDate = Date()
    
    func body(content: Content) -> some View {
        if isEnabled {
            TimelineView(.animation) { _ in
                content
                    .drawingGroup()
                    // .background(Color(red: 243/255, green: 240/255, blue: 229/255))
                    // .colorEffect(ShaderLibrary.hidePixels(
                    //     .float(startDate.timeIntervalSinceNow))
                    // )
                    .distortionEffect(
                        ShaderLibrary.distortionContinuous(
                            .float(startDate.timeIntervalSinceNow)),
                        maxSampleOffset: CGSize(width: 100, height: 200)
                    )
                    .compositingGroup() // Add this
                    .blendMode(.darken) // Try different blend modes
                    
            }
            
        } else {
            content
        }
    }
}

