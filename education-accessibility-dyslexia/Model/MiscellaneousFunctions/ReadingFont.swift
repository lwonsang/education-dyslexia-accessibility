//
//  ReadingFont.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/20/26.
//

import Foundation
import SwiftUI

enum ReadingFont: String, CaseIterable, Identifiable {
    case system
    case dyslexic
    case lexend
    case atkinson

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .system: return "System"
        case .dyslexic: return "OpenDyslexic"
        case .lexend: return "Lexend"
        case .atkinson: return "Atkinson Hyperlegible"
        }
    }

    func font(size: CGFloat) -> Font {
        switch self {
        case .system:
            return .system(size: size)
        case .dyslexic:
            return .custom("OpenDyslexic-Regular", size: size)
        case .lexend:
            return .custom("Lexend-Regular", size: size)
        case .atkinson:
            return .custom("AtkinsonHyperlegible-Regular", size: size)
        }
    }

    func uiFont(size: CGFloat) -> UIFont {
        switch self {
        case .system:
            return .systemFont(ofSize: size)
        case .dyslexic:
            return UIFont(name: "OpenDyslexic-Regular", size: size) ?? .systemFont(ofSize: size)
        case .lexend:
            return UIFont(name: "Lexend-Regular", size: size) ?? .systemFont(ofSize: size)
        case .atkinson:
            return UIFont(name: "AtkinsonHyperlegible-Regular", size: size) ?? .systemFont(ofSize: size)
        }
    }
}
