//
//  SaveSTTButton.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 2/3/26.
//


import SwiftUI

struct SaveSTTButton: View {
    @EnvironmentObject var studyNotesStore: StudyNotesStore
    @State private var pendingNote: StudyNote?

    let sourceType: SourceType
    let originalText: String
    let sentences: [TranscriptSentence]
    let audioURL: URL?

    @Binding var showSavedToast: Bool

    var body: some View {
        let alreadySaved = studyNotesStore.containsText(originalText)

        Button(alreadySaved ? "Saved ✓" : "Save to Study Notes") {
            prepareNote()
        }
        .sheet(item: $pendingNote) { note in
            SaveNoteFolderPickerView(
                baseNote: note,
                onSave: { finalNote in
                    studyNotesStore.add(finalNote)
                    showSaveConfirmation($showSavedToast)
                }
            )
        }
        .disabled(alreadySaved)
        .opacity(alreadySaved ? 0.6 : 1)
    }

    private func prepareNote() {
        let title = generateTitle(from: originalText)
        let persistedURL = audioURL.flatMap { persistAudioFile($0) }

        pendingNote = StudyNote(
            id: UUID(),
            title: title,
            sourceType: .audioFile,
            originalText: originalText,
            sentences: sentences,
            audioURL: persistedURL,
            lastPlaybackPosition: 0,
            createdAt: Date(),
            folderID: nil
        )
    }
    
    func persistAudioFile(_ sourceURL: URL) -> URL? {
        let didStart = sourceURL.startAccessingSecurityScopedResource()
        defer { if didStart { sourceURL.stopAccessingSecurityScopedResource() } }

        let destination = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(sourceURL.pathExtension)

        do {
            let data = try Data(contentsOf: sourceURL)
            try data.write(to: destination, options: .atomic)

            return destination
        } catch {
            print("❌ Failed to persist audio:", error)
            return nil
        }
    }

}
