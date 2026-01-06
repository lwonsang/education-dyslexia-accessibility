//
//  TextInputSection.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/6/26.
//

import SwiftUI

struct TextInputSection: View {
    @Binding var text: String
    @Binding var selectedRange: NSRange
    let onImportFile: (URL) -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(radius: 3)

            VStack {
                CustomTextView(
                    text: $text,
                    selectedRange: $selectedRange
                )
                .frame(height: 150)

                FilesManagementView(mode: .text) { url in
                    onImportFile(url)
                }
            }
            .padding()
        }
    }
}



//#Preview {
//    TextInputSection()
//}
