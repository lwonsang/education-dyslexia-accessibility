//
//  StudySessionModel.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/6/26.
//

import Foundation

struct StudyNotes {
    let id = UUID()
    let title: String
    let sourceType: String
    let originalText: String
    let sentences: [TranscriptSentence]
    let audioURL: String?
//    let notes: [Note]
//    let bookmarks: [Sentence]
    let lastPlaybackPosition: TimeInterval
    let createdAt: Date
}
