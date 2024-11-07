//
//  ContentView.swift
//  LearnMetal
//
//  Created by Jacob Bartlett on 26/10/2023.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        Text("Hello, world!")
            .font(.largeTitle)
            .fontWeight(.bold)
            .wigglyShader()

        Image(systemName: "globe")
            .font(.system(size: 100))
            .foregroundStyle(.blue)
            .dissolveShader()
        Text("Hello, world!")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(.blue)
//                    .wigglyShader()
            .pixellationShader()
//        Color.white
//            .edgesIgnoringSafeArea(.all)
//        shader here is a function on… a view? or a Color?
//        "The iOS 17 colorEffect modifier takes a Shader as an argument"
//            .colorShader()
//            .perlinNoiseShader()
    }
}

#Preview {
    ContentView()
}
