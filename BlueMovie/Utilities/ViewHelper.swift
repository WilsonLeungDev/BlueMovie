//
//  ViewHelper.swift
//  SoFair
//
//  Created by Wilson Leung on 25/1/2022.
//

import SwiftUI

// MARK: Visibility
enum ViewVisibility: CaseIterable {
    case visible, // view is fully visible
         invisible, // view is hidden but takes up space
         gone // view is fully removed from the view hierarchy
}
extension View {
    @ViewBuilder
    func visibility(_ visibility: ViewVisibility) -> some View {
        if visibility != .gone {
            if visibility == .visible {
                self
            } else {
                hidden()
            }
        }
    }
}

// MARK: Label
extension View {
    func gradientBackground() -> some View {
        self.modifier(GradientBackground())
    }
}