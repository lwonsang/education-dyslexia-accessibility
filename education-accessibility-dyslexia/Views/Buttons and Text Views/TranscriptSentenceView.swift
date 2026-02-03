//
//  TranscriptSentenceView.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/2/26.
//

//  The TranscriptSentenceView is the main form of how transcripts are shown in STT view. Users can play audio files while having the transcription follow along to the audio. Users can also skip ahead to desired parts or press on words to open up an image bank. It can then be saved as a Study Note to be read later.

import SwiftUI

struct TranscriptSentenceView: View {
    @EnvironmentObject var settings: AppSettings
    let sentence: TranscriptSentence
    let isCurrent: Bool
    let onSentenceTap: () -> Void
    let onWordTap: (String) -> Void

    var body: some View {
            Text(makeAttributedSentence())
                .background(isCurrent ? settings.highlightColor : .clear)
                .padding(8)
                .cornerRadius(6)
                .contentShape(Rectangle())
                .onTapGesture {
                    onSentenceTap()
                }
                .font(.system(size: settings.fontSize))
                .lineSpacing(settings.lineSpacing)
                .kerning(settings.letterSpacing)
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

