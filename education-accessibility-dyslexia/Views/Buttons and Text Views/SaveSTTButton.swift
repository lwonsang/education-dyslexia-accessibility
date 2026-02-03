//
//  SaveSTTButton.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 2/3/26.
//


import SwiftUI

struct SaveSTTButton: View {
    @EnvironmentObject var studyNotesStore: StudyNotesStore

    let sourceType: SourceType
    let originalText: String
    let sentences: [TranscriptSentence]
    let audioURL: URL?

    @Binding var showSavedToast: Bool

    var body: some View {
        let alreadySaved = studyNotesStore.containsText(originalText)

        Button(alreadySaved ? "Saved ✓" : "Save to Study Notes") {
            saveSTTNote()
        }
        .disabled(alreadySaved)
        .opacity(alreadySaved ? 0.6 : 1)
    }

    private func saveSTTNote() {
        let title = generateTitle(from: originalText)

        let note = StudyNote(
            id: UUID(),
            title: title,
            sourceType: sourceType,
            originalText: originalText,
            sentences: sentences,
            audioURL: audioURL,
            lastPlaybackPosition: 0,
            createdAt: Date()
        )

        studyNotesStore.add(note)
        showSaveConfirmation($showSavedToast)
    }
}
