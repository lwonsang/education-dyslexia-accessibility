//
//  StudyNotesListView.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/7/26.
//

//  This is the Study Notes List view. Users can view their saved study notes here, structured in an easy-to-read manner.

import SwiftUI

struct StudyNotesListView: View {
    @EnvironmentObject var store: StudyNotesStore
    @EnvironmentObject var settings: AppSettings

    var body: some View {
        NavigationStack {
            ZStack {
                settings.backgroundStyle.color
                    .ignoresSafeArea()

                if store.notes.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(store.notes) { note in
                            NavigationLink {
                                StudyNoteDetailView(noteID: note.id)
                            } label: {
                                StudyNoteRowView(note: note)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet
                                .map { store.notes[$0] }
                                .forEach(store.delete)
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Study Notes")
            .toolbar {
                EditButton()
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "book.closed")
                .font(.system(size: 40))
                .foregroundColor(.secondary)

            Text("No Study Notes Yet")
                .font(.headline)

            Text("Save transcripts or text to revisit them later.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

