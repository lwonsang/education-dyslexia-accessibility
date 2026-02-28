//
//  TextInputSection.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/6/26.
//

//  Used for TextToSpeechView, users can manually input or change text that they have uploaded. Changes to TranscriptSentenceView when the audio is played out loud. Consists of CustomTextView (that actually allows for the manual text update) and FilesManagementView, that allows users to upload text files.

import SwiftUI

struct TextInputSection: View {
    @EnvironmentObject var settings: AppSettings
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
                    selectedRange: $selectedRange,
                    fontSize: settings.fontSize,
                    lineSpacing: settings.lineSpacing,
                    letterSpacing: settings.letterSpacing
                )
                .background(.gray.opacity(0.1))
                .frame(height: 400)

                FilesManagementView(mode: .text) { url in
                    onImportFile(url)
                }
                .padding()
            }
            .padding()
        }
        .onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
        }
    }
}



//#Preview {
//    TextInputSection()
//}
