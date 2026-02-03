//
//  AudioFileSTTView.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 2/3/26.
//

import SwiftUI

struct AudioFileSTTView: View {
    @StateObject private var assemblyai = AssemblyAIViewModel()
    @EnvironmentObject var studyNotesStore: StudyNotesStore
    @EnvironmentObject var settings: AppSettings

    @State private var audioURL: URL?
    @State private var showSavedToast = false
    @State private var showingHelp = false
    @State private var showingSettings = false

    var body: some View {
        VStack(spacing: 20) {
            FilesManagementView(mode: .audio) { file in
                guard !assemblyai.isLoading else { return }
                audioURL = file
                Task {
                    await assemblyai.transcribeAudio(at: file)
                }
            }

            if assemblyai.isLoading {
                ProgressView("Transcribing…")
            }

            if let url = audioURL, !assemblyai.sentences.isEmpty {
                AudioFileTranscriptView(
                    assemblyai: assemblyai,
                    audioURL: url
                )
                .frame(maxHeight: 350)

                SaveSTTButton(
                    sourceType: .audioFile,
                    originalText: assemblyai.transcriptText,
                    sentences: assemblyai.sentences,
                    audioURL: url,
                    showSavedToast: $showSavedToast
                )
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(settings.backgroundStyle.color)
        .navigationTitle("Audio File Transcription")
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
    }
}
//
//
//#Preview {
//    AudioFileSTTView()
//}
