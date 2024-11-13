import SwiftUI

struct SandEffect: ViewModifier {
    private let startDate = Date()
    
    func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in 
            let currentTime = startDate.timeIntervalSinceNow
            
            content
                .drawingGroup()
                // First simulate which particles should move
                .layerEffect(
                    ShaderLibrary.default.sandSimulation(
                        .float2(
                            Float(UIScreen.main.bounds.width),
                            Float(UIScreen.main.bounds.height)
                        ),
                        .float(currentTime)
                    ),
                    maxSampleOffset: CGSize(width: 100, height: 100)
                )
                // Then immediately apply the receive shader to move them
                // .layerEffect(
                //     ShaderLibrary.default.sandReceive(
                //         .float2(
                //             Float(UIScreen.main.bounds.width),
                //             Float(UIScreen.main.bounds.height)
                //         ),
                //         .float(currentTime)
                //     ),
                //     maxSampleOffset: CGSize(width: 100, height: 100)
                // )
        }
    }
}

// Simplified extension
extension View {
    func sandEffect() -> some View {
        modifier(SandEffect())
    }
}



