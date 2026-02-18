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
    
    @State private var showingNewFolderSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                settings.backgroundStyle.color
                    .ignoresSafeArea()

                if store.notes.isEmpty {
                    emptyState
                } else {
                    List {
                        Section {
                            NavigationLink {
                                NotesListView(notes: store.notes)
                            } label: {
                                HStack {
                                    Label("All Notes", systemImage: "tray.full")
                                    Spacer()
                                    Text("\(store.notes.count)")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }

                        Section("Folders") {
                            ForEach(store.folders) { folder in
                                NavigationLink {
                                    NotesListView(
                                        notes: store.notes.filter { $0.folderID == folder.id }
                                    )
                                } label: {
                                    HStack {
                                        Label(folder.name, systemImage: "folder")

                                        Spacer()

                                        Text("\(store.noteCount(in: folder))")
                                            .foregroundColor(.secondary)
                                            .font(.subheadline)
                                    }
                                }
                            }
                            .onDelete { indexSet in
                                indexSet
                                    .map { store.folders[$0] }
                                    .forEach(store.deleteFolder)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Study Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingNewFolderSheet = true
                    } label: {
                        Image(systemName: "folder.badge.plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewFolderSheet) {
                NewFolderView()
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

