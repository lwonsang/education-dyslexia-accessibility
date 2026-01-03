//
//  WordBankImageGrid.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/2/26.
//

import SwiftUI

struct WordBankImageGrid: View {
    let query: String

    @StateObject private var viewModel = PixabayWordViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading images…")
                    .frame(maxWidth: .infinity)
            } else if viewModel.images.isEmpty {
                Text("No images found")
                    .foregroundColor(.secondary)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.images, id: \.id) { image in
                            WordBankImageCell(image: image)
                        }
                    }
                }
            }
        }
        .task(id: query) {
            await viewModel.search(word: query)
        }
    }
}
