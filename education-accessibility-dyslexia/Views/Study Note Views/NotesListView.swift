//
//  NotesListView.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 2/4/26.
//

// This view provides all of the available study notes for StudyNotesListView to use.

import SwiftUI

struct NotesListView: View {
    let notes: [StudyNote]

    @EnvironmentObject var store: StudyNotesStore
    @EnvironmentObject var settings: AppSettings

    var body: some View {
        List {
            ForEach(notes) { note in
                NavigationLink {
                    StudyNoteDetailView(noteID: note.id)
                } label: {
                    StudyNoteRowView(note: note)
                }
            }
            .onDelete { indexSet in
                indexSet
                    .map { notes[$0] }
                    .forEach(store.delete)
            }
        }
        .scrollContentBackground(.hidden)
        .background(settings.backgroundStyle.color)
    }
}
