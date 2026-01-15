//
//  StudyNoteRowView.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/7/26.
//

//  This is the Study Notes Row view. StudyNotesListView receives each individual saved study notes and displays it so that users can select and/or delete or go into further detail with StudyNoteDetailView.

import SwiftUI

struct StudyNoteRowView: View {
    let note: StudyNote

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(note.title!)
                .font(.headline)

            HStack(spacing: 12) {
                Label(note.sourceType.displayName, systemImage: note.sourceType.icon)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(note.createdAt, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}


//#Preview {
//    StudyNoteRowView()
//}
