import SwiftUI

struct SandEffect: ViewModifier {
    let startTime = Date()
    
    func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in  // Add TimelineView for continuous updates
            content
                .drawingGroup()
                .layerEffect(
                    ShaderLibrary.default.sandSimulation(
                        .float2(Float(800), Float(600)),  // resolution
                        .float(Float(startTime.timeIntervalSinceNow))  // time
                    ),
                    maxSampleOffset: CGSize(width: 30, height: 30)
                )
        }
    }
}

// Convenience extension for using the effect
extension View {
    func sandEffect() -> some View {
        modifier(SandEffect())
    }
}



