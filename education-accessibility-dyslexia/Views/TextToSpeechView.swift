//
//  TextToSpeechView.swift
//  DyslexiaAccessibilityApp
//
//  Created by Wonsang Lee on 11/18/25.
//

import SwiftUI

struct TextToSpeechView: View {
    @StateObject private var speech = SpeechViewModel()
    @State private var text = "This app can help students with dyslexia by reading text aloud."
    @State private var rate = Float(0.45)
    @FocusState var focusValue: Int?

    var body: some View {
        VStack(spacing: 20) {
            TextEditor(text: $text)
                .focused($focusValue, equals: 1)
                .padding()
                .frame(height: 150)
                .border(Color.gray)

            Button(speech.isSpeaking ? "Stop" : "Speak") {
                if speech.isSpeaking {
                    speech.stop()
                } else {
                    speech.speak(text, rate: rate)
                }
                focusValue = nil
            }
            .font(.title2)
            .padding()
        }
        .padding()
    }
}

#Preview {
    TextToSpeechView()
}
