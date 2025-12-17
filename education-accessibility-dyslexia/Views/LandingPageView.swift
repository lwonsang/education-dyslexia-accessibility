//
//  LandingPageView.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 12/16/25.
//

import SwiftUI

struct LandingPageView: View {
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

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    LandingPageView()
}
