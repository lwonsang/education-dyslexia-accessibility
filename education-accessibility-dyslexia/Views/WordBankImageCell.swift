//
//  WordBankImageCell.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/2/26.
//

import SwiftUI

struct WordBankImageCell: View {
    let image: PixabayImage

    var body: some View {
        AsyncImage(url: URL(string: image.previewURL)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: 120, height: 120)

            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipped()
                    .cornerRadius(10)

            case .failure:
                Image(systemName: "photo")
                    .frame(width: 120, height: 120)

            @unknown default:
                EmptyView()
            }
        }
    }
}
