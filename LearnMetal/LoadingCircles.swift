//
//  LoadingCircles.swift
//  LearnMetal
//
//  Created by Barron Webster on 12/9/24.
//

import SwiftUI

struct LoadingCircles: View {
    @State private var startDate = Date()
    
    var body: some View {
        TimelineView(.animation) { _ in
            ZStack {
                ForEach(0..<4, id: \.self) { index in
                let progress = getProgress(for: index)
                    Circle()
                        .stroke(Color.black.opacity(1.0 - getScale(for: progress)), lineWidth: 2)
                        .scaleEffect(getScale(for: progress))
                }
            }
            .drawingGroup() // Optimize rendering
        }
    }
    
    private func getProgress(for index: Int) -> Double {
        let baseProgress = -startDate.timeIntervalSinceNow.truncatingRemainder(dividingBy: 5.0) / 5.0
        let staggered = baseProgress + Double(index) * 0.25
        return staggered.truncatingRemainder(dividingBy: 1.0)
    }
    
    private func getScale(for progress: Double) -> Double {
        // let progress = getProgress(for: index)
        // Convert progress (0...1) to a logarithmic scale
        let minScale = 0.2
        let maxScale = 1.0
        let logProgress = log(progress * 19 + 1) / log(20) // Maps 0...1 to 0...1 logarithmically
        return minScale + (maxScale - minScale) * logProgress
    }
}
