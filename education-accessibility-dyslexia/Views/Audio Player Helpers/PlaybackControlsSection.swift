//
//  PlaybackControlsSection.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/6/26.
//

//  Part of TextToSpeechView, allows users to play, puase, or reset their audio.

import SwiftUI

struct PlaybackControlsSection: View {
    let isSpeaking: Bool
    let onSpeak: () -> Void
    let onPause: () -> Void
    let onReset: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(isSpeaking ? "Pause" : "Speak") {
                isSpeaking ? onPause() : onSpeak()
            }

            Button("Reset") {
                onReset()
            }
        }
        .font(.title2)
        .padding()
    }
}
