//
//  NewFolderView.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 2/4/26.
//

// This view shows all of the new folders that the user has created.

import SwiftUI

struct NewFolderView: View {
    @EnvironmentObject var store: StudyNotesStore
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Folder name", text: $name)
            }
            .navigationTitle("New Folder")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        store.addFolder(
                            StudyFolder(
                                id: UUID(),
                                name: name,
                                createdAt: Date()
                            )
                        )
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
