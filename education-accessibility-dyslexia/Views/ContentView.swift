//
//  NavigationView.swift
//  DyslexiaAccessibilityApp
//
//  Created by Wonsang Lee on 11/18/25.
//
// Acts as a landing page. Can open different views starting from here, including TTS, STT, and Study Notes.

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settings: AppSettings
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                Text("Accessibility Tools")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Tools to support reading and listening")
                    .foregroundColor(.secondary)

                NavigationLink {
                    TextToSpeechView()
                } label: {
                    FeatureButton(
                        title: "Text to Speech",
                        subtitle: "Read text out loud",
                        systemImage: "text.bubble"
                    )
                }

                NavigationLink {
                    SpeechToTextView()
                } label: {
                    FeatureButton(
                        title: "Speech to Text",
                        subtitle: "Transcribe audio files",
                        systemImage: "waveform"
                    )
                }
                
                NavigationLink {
                    StudyNotesListView()
                } label: {
                    FeatureButton(
                        title: "Your Study Notes",
                        subtitle: "All of your saved files",
                        systemImage: "book.pages"
                    )
                }

                Spacer()
            }
            .padding()
            .background(settings.backgroundStyle.color)
        }
    }
}

#Preview {
    ContentView()
}
