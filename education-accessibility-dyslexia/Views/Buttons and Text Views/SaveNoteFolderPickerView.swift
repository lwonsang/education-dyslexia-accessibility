//
//  SaveNoteFolderPickerView.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 2/17/26.
//

import SwiftUI

struct SaveNoteFolderPickerView: View {
    @EnvironmentObject var store: StudyNotesStore
    @Environment(\.dismiss) private var dismiss

    let baseNote: StudyNote
    let onSave: (StudyNote) -> Void

    var body: some View {
        NavigationStack {
            List {
                Button {
                    save(folderID: nil)
                } label: {
                    Label("All Notes", systemImage: "tray")
                }

                Section("Folders") {
                    ForEach(store.folders) { folder in
                        Button {
                            save(folderID: folder.id)
                        } label: {
                            Label(folder.name, systemImage: "folder")
                        }
                    }
                }
            }
            .navigationTitle("Save To")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private func save(folderID: UUID?) {
        var note = baseNote
        note.folderID = folderID
        onSave(note)
        dismiss()
    }
}
