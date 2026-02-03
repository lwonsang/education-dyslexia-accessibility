//
//  LiveMicSTTView.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 2/3/26.
//

import SwiftUI

struct LiveMicSTTView: View {
    @StateObject private var speechframework = SpeechFrameworkViewModel()
    @EnvironmentObject var studyNotesStore: StudyNotesStore
    @EnvironmentObject var settings: AppSettings

    @State private var canSaveTranscript = false
    @State private var showSavedToast = false
    @State private var showingHelp = false
    @State private var showingSettings = false

    var body: some View {
        VStack(spacing: 20) {
            Text(speechframework.transcript)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Button("Start Mic") {
                    speechframework.start()
                }

                Button("Stop") {
                    speechframework.stop()
                    canSaveTranscript = true
                }
            }

            if canSaveTranscript && !speechframework.transcript.isEmpty {
                let sentences = TextSentenceCreator()
                    .createSentences(from: speechframework.transcript)

                SaveSTTButton(
                    sourceType: .liveMic,
                    originalText: speechframework.transcript,
                    sentences: sentences,
                    audioURL: nil,
                    showSavedToast: $showSavedToast
                )
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(settings.backgroundStyle.color)
        .navigationTitle("Live Microphone Transcription")
        .modifier(
            STTToolbarModifier(
                showingHelp: $showingHelp,
                showingSettings: $showingSettings
            )
        )
        .sheet(isPresented: $showingHelp) {
            HelpTutorialView(
                title: "Live Mic Help",
                sections: sttHelpSections
            )
        }
        .sheet(isPresented: $showingSettings) {
            NavigationStack {
                SettingsView()
            }
        }
        .modifier(SaveToastModifier(isShowing: $showSavedToast))
        .onDisappear {
            speechframework.stop()
        }
    }
}


//#Preview {
//    LiveMicSTTView()
//}
