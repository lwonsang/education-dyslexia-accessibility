//
//  StudyNoteDetailView.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/7/26.
//

//  This is the Study Notes Detail view. StudyNoteDetailView shows a more detailed view for each saved Study Note.

import SwiftUI

struct StudyNoteDetailView: View {
    let note: StudyNote
    @EnvironmentObject var store: StudyNotesStore
    @EnvironmentObject var settings: AppSettings
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(note.title!)
                    .font(.title2)
                    .bold()

                ForEach(note.sentences) { sentence in
                    Text(sentence.text)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .scrollContentBackground(.hidden)
        .background(settings.backgroundStyle.color)
        .navigationTitle(note.title!)
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
