//
//  TimedSentenceCreator.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/5/26.
//

//  The model behind creating sentences for STT transcripts to allow for audio-based following along and playback.

import Foundation

struct TimedSentenceCreator {
    func createSentences(from words: [Word]) -> [TranscriptSentence] {
        var sentences: [TranscriptSentence] = []
        var buffer: [Word] = []

        func flush() {
            guard let first = buffer.first,
                  let last = buffer.last else { return }

            sentences.append(
                TranscriptSentence(
                    text: buffer.map(\.text).joined(separator: " "),
                    start: TimeInterval(first.start) / 1000,
                    end: TimeInterval(last.end) / 1000
                )
            )
            buffer.removeAll()
        }

        for word in words {
            buffer.append(word)

            let endsSentence = [".", "?", "!"].contains {
                word.text.hasSuffix($0)
            }

            let tooLong = buffer.count >= 12

            if endsSentence || tooLong {
                flush()
            }
        }

        flush()
        return sentences
    }
}
