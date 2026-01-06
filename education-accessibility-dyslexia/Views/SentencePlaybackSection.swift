//
//  SentencePlaybackSection.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/6/26.
//

import SwiftUI

struct SentencePlaybackSection: View {
    let sentences: [TranscriptSentence]
    let currentSentenceIndex: Int?
    let onWordTap: (String) -> Void

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(sentences.indices, id: \.self) { index in
                        TranscriptSentenceView(
                            sentence: sentences[index],
                            isCurrent: index == currentSentenceIndex,
                            onWordTap: onWordTap
                        )
                        .id(index)
                    }
                }
                .padding()
            }
            .onChange(of: currentSentenceIndex) { index in
                guard let index else { return }
                withAnimation {
                    proxy.scrollTo(index, anchor: .center)
                }
            }
        }
    }
}


//#Preview {
//    SentencePlaybackSection()
//}
