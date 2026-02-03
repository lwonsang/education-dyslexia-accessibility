//
//  SpeechToTextView.swift
//  DyslexiaAccessibilityApp
//
//  Created by Wonsang Lee on 11/18/25.
//

//  The SpeechToTextView is the main view for all of the SpeechToTextView functionalities. Users can either transcribe their live speech into text form or upload audio files (and later video files) to be transcribed as text. Users can then play those audio files while having the transcription follow along to the audio. Users can also skip ahead to desired parts or press on words to open up an image bank. It can then be saved as a Study Note to be read later.

import SwiftUI
internal import UniformTypeIdentifiers

struct SpeechToTextView: View {
    @EnvironmentObject var settings: AppSettings
    @State private var showingHelp = false
    @State private var showingSettings = false

    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Live Microphone Transcription") {
                    LiveMicSTTView()
                }

                NavigationLink("Transcribe Audio File") {
                    AudioFileSTTView()
                }
            }
            .scrollContentBackground(.hidden)
            .background(settings.backgroundStyle.color)
            .navigationTitle("Speech to Text")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingHelp = true
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showingHelp) {
                HelpTutorialView(
                    title: "Speech to Text Help",
                    sections: sttHelpSections
                )
            }
            .sheet(isPresented: $showingSettings) {
                NavigationStack {
                    SettingsView()
                }
            }
        }
    }
}
