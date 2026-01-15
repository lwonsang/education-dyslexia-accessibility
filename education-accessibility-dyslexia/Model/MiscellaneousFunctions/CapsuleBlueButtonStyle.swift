//
//  CapsuleBlueButtonStyle.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/6/26.
//

import Foundation
import SwiftUI

struct CapsuleBlueButtonStyle: ButtonStyle {
    let height: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: height)
            .padding()
            .foregroundColor(.white)
            .background(Capsule().fill(.blue))
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

extension ButtonStyle where Self == CapsuleBlueButtonStyle {
    static func capsuleBlue(height: CGFloat) -> Self {
        CapsuleBlueButtonStyle(height: height)
    }
}
