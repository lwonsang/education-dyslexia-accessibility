//
//  TranscriptSentenceView.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/2/26.
//

import SwiftUI

struct TranscriptSentenceView: View {
    let sentence: TranscriptSentence
    let isCurrent: Bool
    let onSentenceTap: () -> Void
    let onWordTap: (String) -> Void

    var body: some View {
            Text(makeAttributedSentence())
                .background(isCurrent ? Color.yellow.opacity(0.3) : .clear)
                .padding(8)
                .cornerRadius(6)
                .contentShape(Rectangle())
                .onTapGesture {
                    onSentenceTap()
                }
    }
    

}
extension TranscriptSentenceView {

    func makeAttributedSentence() -> AttributedString {
        var attributed = AttributedString(sentence.text)

        let words = sentence.text
            .components(separatedBy: .whitespacesAndNewlines)

        for word in words {
            let cleaned = word.trimmingCharacters(in: .punctuationCharacters)
            guard !cleaned.isEmpty else { continue }

            if let range = attributed.range(of: cleaned) {
                attributed[range].foregroundColor = .black
//                attributed[range].underlineStyle = .single


                attributed[range].link = URL(string: "wordbank://\(cleaned.lowercased())")
            }
        }

        return attributed
    }
}

