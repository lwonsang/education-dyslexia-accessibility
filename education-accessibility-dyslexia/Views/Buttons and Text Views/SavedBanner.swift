//
//  SavedBanner.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/6/26.
//

//  Text view (like the original button) to be shown when the user has already saved a file.

import SwiftUI

struct SavedToast: View {
    var body: some View {
        Text("Saved to Study Notes ✓")
            .font(.subheadline)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.green.opacity(0.9))
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(radius: 4)
    }
}

