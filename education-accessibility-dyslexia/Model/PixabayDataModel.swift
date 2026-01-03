//
//  PixabayDataModel.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 12/30/25.
//

import Foundation
import SwiftUI
import UIKit
internal import Combine

enum PIXABAY_API_KEY {
    static var value: String {
        guard let key = Bundle.main.infoDictionary?["PIXABAY_API_KEY"] as? String,
              !key.isEmpty
        else {
            fatalError("PIXABAY_API_KEY not set")
        }
        return key
    }
}


struct PixabayImage: Decodable {
    let id: Int
    let previewURL: String
    let largeImageURL: String
}

struct PixabayResponse: Decodable {
    let hits: [PixabayImage]
}

final class PixabayService {

    func fetchImages(for word: String) async throws -> [PixabayImage] {
        let query = word.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString =
        "https://pixabay.com/api/?key=\(PIXABAY_API_KEY.value)&q=\(query)&image_type=photo&per_page=5"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(PixabayResponse.self, from: data)
        return decoded.hits
    }
}

