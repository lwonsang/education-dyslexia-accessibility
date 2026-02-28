//
//  StudySessionModel.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/6/26.
//

//  The models behind each Study Note.

import Foundation
internal import Combine

struct StudyNote: Identifiable, Codable {
    let id: UUID
    var title: String?
    let sourceType: SourceType
    let originalText: String
    var sentences: [TranscriptSentence]
    let audioURL: URL?
    var lastPlaybackPosition: TimeInterval
    let createdAt: Date
    var folderID: UUID?
}

struct StudyFolder: Identifiable, Codable {
    let id: UUID
    var name: String
    let createdAt: Date
}

enum SourceType: String, Codable {
    case liveMic
    case audioFile
    case pdf
    case typedText
    case scannedText
    case text

    var displayName: String {
        switch self {
        case .liveMic: return "Live Mic"
        case .audioFile: return "Audio File"
        case .pdf: return "PDF"
        case .typedText: return "Typed Text"
        case .scannedText: return "Scanned Text"
        case .text: return "Text"
        }
    }

    var icon: String {
        switch self {
        case .liveMic: return "mic.fill"
        case .audioFile: return "waveform"
        case .pdf: return "doc.richtext"
        case .typedText: return "text.cursor"
        case .scannedText: return "text.cursor"
        case .text: return "text.cursor"
        }
    }
}

struct StudyNotesPersistence: Codable {
    let notes: [StudyNote]
    let folders: [StudyFolder]
}

final class StudyNotesStore: ObservableObject {
    @Published private(set) var notes: [StudyNote] = []
    @Published private(set) var folders: [StudyFolder] = []

    private let saveURL: URL = {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("study_notes.json")
    }()

    init() {
        load()
    }

    func add(_ note: StudyNote) {
        guard !contains(note) else {return}
        notes.insert(note, at: 0)
        save()
    }

    func update(_ note: StudyNote) {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else { return }
        notes[index] = note
        save()
    }
    
    func delete(_ note: StudyNote) {
        notes.removeAll { $0.id == note.id }
    }
    
    func addFolder(_ folder: StudyFolder) {
        folders.append(folder)
        save()
    }

    func deleteFolder(_ folder: StudyFolder) {
        // optional: unassign notes
        notes = notes.map {
            var n = $0
            if n.folderID == folder.id {
                n.folderID = nil
            }
            return n
        }
        folders.removeAll { $0.id == folder.id }
        save()
    }

    private func save() {
        let data = StudyNotesPersistence(
            notes: notes,
            folders: folders
        )

        do {
            let encoded = try JSONEncoder().encode(data)
            try encoded.write(to: saveURL)
        } catch {
            print("Save error:", error)
        }
    }
    
    private func load() {
        do {
            let data = try Data(contentsOf: saveURL)
            let decoded = try JSONDecoder().decode(StudyNotesPersistence.self, from: data)
            notes = decoded.notes
            folders = decoded.folders
        } catch {
            print("Load error:", error)
        }
    }
    
    func assign(noteID: UUID, to folderID: UUID?) {
        guard let index = notes.firstIndex(where: { $0.id == noteID }) else { return }
        notes[index].folderID = folderID
        save()
    }
    
    func contains(_ note: StudyNote) -> Bool {
        notes.contains { $0.originalText == note.originalText }
    }

    func containsText(_ text: String) -> Bool {
        notes.contains { $0.originalText == text }
    }
    
    func updateSentenceMark(
        noteID: UUID,
        sentenceID: UUID,
        mark: SentenceMark
    ) {
        guard let noteIndex = notes.firstIndex(where: { $0.id == noteID }) else {
            return
        }

        var note = notes[noteIndex]

        guard let sentenceIndex = note.sentences.firstIndex(where: { $0.id == sentenceID }) else {
            return
        }

        note.sentences[sentenceIndex].mark = mark

        notes[noteIndex] = note
        save()
    }
    
    var allNotesCount: Int {
        notes.count
    }

    func noteCount(in folder: StudyFolder) -> Int {
        notes.filter { $0.folderID == folder.id }.count
    }

}
