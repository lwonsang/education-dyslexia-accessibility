//
//  SentencePlaybackSection.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/6/26.
//

// Part of AudioFileTranscriptView, allows user to select a part of their transcript to skip to.

import SwiftUI

struct SentencePlaybackSection: View {
    let sentences: [TranscriptSentence]
    let currentSentenceIndex: Int?
    let onSentenceTap: (Int) -> Void
    let onWordTap: (String) -> Void

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(sentences.enumerated()), id: \.element.id) { index, sentence in
                        TranscriptSentenceView(
                            sentence: sentence,
                            isCurrent: index == currentSentenceIndex,
                            onSentenceTap: {
                                onSentenceTap(index)
                            },
                            onWordTap: onWordTap
                        )
                        .id(sentence.id)
                    }
                }
                .padding()
            }
            .onChange(of: currentSentenceIndex) { index in
                guard
                    let index,
                    sentences.indices.contains(index)
                else { return }

                let id = sentences[index].id

                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo(id, anchor: .center)
                }
            }

        }
    }
}


//#Preview {
//    SentencePlaybackSection()
//}
