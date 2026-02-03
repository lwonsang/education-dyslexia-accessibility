//
//  AppSettings.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/20/26.
//

//  Marks basic app settings, user should be able  to adjust to their needs.

import Foundation
import SwiftUI

internal import Combine

@MainActor
final class AppSettings: ObservableObject {

    // MARK: Audio
    @Published var speechRate: Float = 1.0
    @Published var pauseBetweenSentences: TimeInterval = 0.4

    // MARK: Text
    @Published var fontSize: CGFloat = 18
    @Published var lineSpacing: CGFloat = 6
    @Published var letterSpacing: CGFloat = 0.5

    @Published var fontStyle: ReadingFont = .system
    @Published var backgroundStyle: ReadingBackground = .cream
    @Published var highlightColor: Color = .yellow.opacity(0.3)

    // MARK: Behavior
    @Published var autoScrollEnabled = true
}
