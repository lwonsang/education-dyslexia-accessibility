//
//  ReadingBackground.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/20/26.
//

import Foundation
import SwiftUI

enum ReadingBackground: String, CaseIterable, Identifiable {
    case white
    case cream
    case gray
    case dark

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .white: return "White"
        case .cream: return "Cream"
        case .gray: return "Gray"
        case .dark: return "Dark"
        }
    }

    var color: Color {
        switch self {
        case .white: return .white
        case .cream: return Color(red: 1.0, green: 0.98, blue: 0.9)
        case .gray: return Color(white: 0.95)
        case .dark: return Color.black
        }
    }
}
