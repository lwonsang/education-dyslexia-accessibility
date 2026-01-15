//
//  HelpTutorialView.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/14/26.
//

//  HelpTutorialView provides helpful advice for users who don't know how to use this app.

import SwiftUI

struct HelpTutorialView: View {
    let title: String
    let sections: [HelpSection]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ForEach(sections) { section in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(section.title)
                                .font(.headline)

                            Text(section.body)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct HelpSection: Identifiable {
    let id = UUID()
    let title: String
    let body: String
}

let ttsHelpSections = [
    HelpSection(
        title: "Text Input",
        body: "Type text manually, upload a PDF, or scan text using the camera."
    ),
    HelpSection(
        title: "Text to Speech",
        body: "Tap Speak to hear the text read aloud. The current sentence will be highlighted."
    ),
    HelpSection(
        title: "Sentence Navigation",
        body: "Tap a sentence to jump playback to that part of the text."
    ),
    HelpSection(
        title: "Word Images",
        body: "Tap any word to open an image-based definition to support understanding."
    ),
    HelpSection(
        title: "Study Notes",
        body: "Save your session to revisit the text and audio later."
    )
]

let sttHelpSections = [
    HelpSection(
        title: "Live Microphone Transcription",
        body: "Use the mic to transcribe speech in real time."
    ),
    HelpSection(
        title: "Audio File Transcription",
        body: "Upload an audio file to generate a transcript with synced playback."
    ),
    HelpSection(
        title: "Sentence Highlighting",
        body: "As audio plays, the current sentence is highlighted automatically."
    ),
    HelpSection(
        title: "Navigation",
        body: "Tap a sentence to jump to that part of the audio."
    ),
    HelpSection(
        title: "Study Notes",
        body: "Save transcripts to review and study later."
    )
]

