//
//  TextSentenceCreator.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/5/26.
//

import Foundation
import NaturalLanguage

struct TextSentenceCreator {

    func createSentences(from text: String) -> [TranscriptSentence] {
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text

        var sentences: [TranscriptSentence] = []

        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            let sentence = text[range].trimmingCharacters(in: .whitespacesAndNewlines)
            guard !sentence.isEmpty else { return true }

            sentences.append(
                TranscriptSentence(
                    text: String(sentence),
                    start: nil,
                    end: nil
                )
            )
            return true
        }

        return sentences
    }
}

