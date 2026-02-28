//
//  TranscriptSentenceModels.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 2/3/26.
//

// The model used to build a transcript sentence, which is used to separate out the text in STT pipelines for readability.

import Foundation

struct TranscriptionResult: Codable {
    let id: String
    let status: String
    let text: String?
    let error: String?
    let words: [Word]?
    
}

struct TranscriptSentence: Identifiable, Codable {
    var id = UUID()
    let text: String
    let start: TimeInterval?
    let end: TimeInterval?
    var mark: SentenceMark = .none
}


struct Word: Codable {
    let text: String
    let start: Int
    let end: Int
}

struct TranscriptWord: Identifiable {
    let id: Int
    let text: String
}

enum SentenceMark: String, Codable {
    case none
    case important
    case review
    case question
}
