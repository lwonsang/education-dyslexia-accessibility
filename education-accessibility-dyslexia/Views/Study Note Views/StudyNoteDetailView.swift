//
//  StudyNoteDetailView.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/7/26.
//

//  This is the Study Notes Detail view. StudyNoteDetailView shows a more detailed view for each saved Study Note.

import SwiftUI

struct StudyNoteDetailView: View {
    let noteID: UUID

    @EnvironmentObject var store: StudyNotesStore
    @EnvironmentObject var settings: AppSettings
    @Environment(\.dismiss) private var dismiss

    private var note: StudyNote? {
        store.notes.first { $0.id == noteID }
    }

    var body: some View {
        Group {
            if let note {
                content(for: note)
            } else {
                Text("Note not found")
                    .foregroundColor(.secondary)
            }
        }
        .background(settings.backgroundStyle.color)
    }

    @ViewBuilder
    private func content(for note: StudyNote) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(note.title ?? "Untitled")
                    .font(.title2)
                    .bold()

                ForEach(note.sentences) { sentence in
                    StudyNoteSentenceView(
                        sentence: sentence,
                        onMark: { newMark in
                            store.updateSentenceMark(
                                noteID: note.id,
                                sentenceID: sentence.id,
                                mark: newMark
                            )
                        }
                    )
                }
            }
            .padding()
        }
        .scrollContentBackground(.hidden)
        .navigationTitle(note.title ?? "Study Note")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(role: .destructive) {
                    store.delete(note)
                    dismiss()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }
}

