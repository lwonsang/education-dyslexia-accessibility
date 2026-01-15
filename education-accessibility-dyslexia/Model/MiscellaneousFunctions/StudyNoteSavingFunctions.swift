//
//  StudyNoteSavingFunctions.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/14/26.
//

import Foundation
import SwiftUI

func generateTitle(from text: String) -> String {
    let trimmed = text
        .trimmingCharacters(in: .whitespacesAndNewlines)

    guard !trimmed.isEmpty else {
        return "Study Note – \(Date().formatted(date: .abbreviated, time: .omitted))"
    }

    let maxLength = 50
    let title = trimmed.prefix(maxLength)

    return title.hasSuffix(".")
        ? String(title)
        : String(title) + "…"
}

func showSaveConfirmation(_ isShowing: Binding<Bool>, duration: TimeInterval = 2) {
    isShowing.wrappedValue = true

    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
        isShowing.wrappedValue = false
    }
}
