//
//  PixabayWordViewModel.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/2/26.
//

//  The model behind fetching images from Pixabay. Uses PixabayDataModel's PixabayService to fetch Pixabay images.

import Foundation
internal import Combine

@MainActor
class PixabayWordViewModel: ObservableObject {
    @Published var images: [PixabayImage] = []
    @Published var isLoading = false

    func search(word: String) async {
        isLoading = true
        do {
            images = try await PixabayService().fetchImages(for: word)
        } catch {
            images = []
        }
        isLoading = false
    }
}
