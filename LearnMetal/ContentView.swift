//
//  ContentView.swift
//  LearnMetal
//
//  Created by Jacob Bartlett on 26/10/2023.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
//        Text("Hello, we\nlove sand!")
//            .font(.largeTitle)
//            .fontWeight(.bold)
//            .sandEffect()
        
       Button(action: {}) {
           HStack {
               Image(systemName: "globe")
                   .font(.system(size: 24))
               Text("Sandify")
                   .font(.headline)
           }
           .foregroundStyle(.black)
           .padding()
           .frame(minWidth: 200)
           .background(.cyan.opacity(0.2))
           .clipShape(RoundedRectangle(cornerRadius: 8))
       }
//       .wigglyShader()
       .sandyShader()
       
        
//        Image(systemName: "globe")
//            .font(.system(size: 100))
//            .foregroundStyle(.blue)
//            .sandEffect()
//
        
        
    //        Rectangle()  // Use Rectangle instead of Color for guaranteed dimensions
    //                .fill(Color.blue)  // Give it a visible color
    //                .frame(width: 800, height: 600)  // Match our resolution
    //                .edgesIgnoringSafeArea(.all)
    //                .sandEffect()
//        Text("Hello, world!")
//            .font(.largeTitle)
//            .fontWeight(.bold)
//            .foregroundStyle(.blue)
////                    .wigglyShader()
//            .pixellationShader()
//        Color.blue
//            .edgesIgnoringSafeArea(.all)
////        shader here is a function on… a view? or a Color?
////        "The iOS 17 colorEffect modifier takes a Shader as an argument"
////            .turbNoiseShader()
//            .sandEffect()
        
    }
}

#Preview {
    ContentView()
}
