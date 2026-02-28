//
//  StudyNoteSentenceView.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 2/3/26.
//

// This view takes each individual sentence and makes it so that the user can highlight different sentences if so desired.

import SwiftUI

struct StudyNoteSentenceView: View {
    let sentence: TranscriptSentence
    let onMark: (SentenceMark) -> Void

    var backgroundColor: Color {
        switch sentence.mark {
        case .important:
            return Color.yellow.opacity(0.25)
        case .review:
            return Color.orange.opacity(0.2)
        case .question:
            return Color.blue.opacity(0.15)
        case .none:
            return Color.clear
        }
    }

    var body: some View {
        Text(sentence.text)
            .padding()
            .background(backgroundColor)
            .cornerRadius(8)
            .contextMenu {
                Button("Mark Important ⭐") {
                    onMark(.important)
                }
                Button("Clear Mark") {
                    onMark(.none)
                }
            }
    }
}
