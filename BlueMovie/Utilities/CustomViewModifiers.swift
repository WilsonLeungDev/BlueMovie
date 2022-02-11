//
//  CustomViewModifiers.swift
//  SoFair
//
//  Created by Wilson Leung on 25/1/2022.
//

import SwiftUI

// MARK: Gradient Background
let futureGradient = LinearGradient(
    gradient: Gradient(colors: [Color("Blue"), .white, Color("Gray")]),
    startPoint: .topLeading, endPoint: .bottomTrailing)

struct GradientBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                futureGradient
            )
    }
}
