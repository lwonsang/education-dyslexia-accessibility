//
//  SaveToastModifier.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/14/26.
//

import SwiftUI

struct SaveToastModifier: ViewModifier {
    @Binding var isShowing: Bool

    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if isShowing {
                        Text("Saved ✓")
                            .padding()
                            .background(.green.opacity(0.9))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .transition(.opacity)
                    }
                },
                alignment: .top
            )
    }
}

