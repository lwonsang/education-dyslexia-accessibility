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
}

enum SourceType: String, Codable {
    case liveMic
    case audioFile
    case pdf
    case typedText

    var displayName: String {
        switch self {
        case .liveMic: return "Live Mic"
        case .audioFile: return "Audio File"
        case .pdf: return "PDF"
        case .typedText: return "Typed Text"
        }
    }

    var icon: String {
        switch self {
        case .liveMic: return "mic.fill"
        case .audioFile: return "waveform"
        case .pdf: return "doc.richtext"
        case .typedText: return "text.cursor"
        }
    }
}


final class StudyNotesStore: ObservableObject {
    @Published private(set) var notes: [StudyNote] = []

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

    private func save() {
        do {
            let data = try JSONEncoder().encode(notes)
            try data.write(to: saveURL)
        } catch {
            print("Failed to save notes:", error)
        }
    }

    private func load() {
        guard let data = try? Data(contentsOf: saveURL) else { return }
        notes = (try? JSONDecoder().decode([StudyNote].self, from: data)) ?? []
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
}
