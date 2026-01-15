//
//  WordBankView.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/2/26.
//

//  This is the Image Word Bank view. Users can select certain individual words from the TranscriptSentenceView to gets individual images from Pixabay relating to that word for further visualization.

import SwiftUI

struct WordBankView: View {
    let word: String
        let onClose: () -> Void

        var body: some View {
            VStack(spacing: 12) {
                HStack {
                    Text(word.capitalized)
                        .font(.headline)

                    Spacer()

                    Button("✕", action: onClose)
                }

                WordBankImageGrid(query: word)
                    .frame(height: 180)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .shadow(radius: 10)
        }
    }


//#Preview {
//    WordBankView()
//}
