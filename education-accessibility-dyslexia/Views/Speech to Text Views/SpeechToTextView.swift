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
    @StateObject private var assemblyai = AssemblyAIViewModel()
    @StateObject private var speechframework = SpeechFrameworkViewModel()
    
    @State private var audioURL: URL?
    @State private var showingFileImporter = false
    @State private var canSaveTranscript = false
    @State private var showSavedToast = false
    @State private var showingHelp = false

    @EnvironmentObject var studyNotesStore: StudyNotesStore
    
    var body: some View {
            VStack(spacing: 30) {
                // MARK: Live Microphone Transcription
                GroupBox("Live Speech to Text (Mic)") {
                    VStack {
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
                            let micSentences = TextSentenceCreator()
                                .createSentences(from: speechframework.transcript)

                            saveSTTButton(
                                sourceType: .liveMic,
                                originalText: speechframework.transcript,
                                sentences: micSentences,
                                audioURL: nil
                            )
                        }

                    }
                }


                // MARK: File-Based Transcription (AssemblyAI)
                GroupBox("Transcribe Audio File") {
                    VStack {
                        FilesManagementView(mode: .audio) { file in
                            guard !assemblyai.isLoading else { return }
                            audioURL = file
                            Task {
                                await assemblyai.transcribeAudio(at: file)
                            }
                            
                        }
                        
                        if assemblyai.isLoading {
                                    ProgressView("Transcribing…")
                                        .padding()
                                }

                        
                        if let fileURL = audioURL, !assemblyai.sentences.isEmpty {
                            AudioFileTranscriptView(assemblyai: assemblyai, audioURL: fileURL)
                                .frame(maxHeight: 350)
                            
                            saveSTTButton(
                                    sourceType: .audioFile,
                                    originalText: assemblyai.transcriptText,
                                    sentences: assemblyai.sentences,
                                    audioURL: fileURL
                                )
                        }
                            
                    }
                .padding()
                }
            }
            .modifier(SaveToastModifier(isShowing: $showSavedToast))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingHelp = true
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }
            .sheet(isPresented: $showingHelp) {
                HelpTutorialView(
                    title: "Speech to Text Help",
                    sections: sttHelpSections
                )
            }
            .navigationBarTitle("Speech To Text Reader")
        }
    
    @ViewBuilder
    func saveSTTButton(
        sourceType: SourceType,
        originalText: String,
        sentences: [TranscriptSentence],
        audioURL: URL?
    ) -> some View {
        let alreadySaved = studyNotesStore.containsText(originalText)

        Button(alreadySaved ? "Saved ✓" : "Save to Study Notes") {
            saveSTTNote(
                sourceType: sourceType,
                originalText: originalText,
                sentences: sentences,
                audioURL: audioURL
            )
        }
        .disabled(alreadySaved)
        .opacity(alreadySaved ? 0.6 : 1)
    }
    
    func saveSTTNote(
        sourceType: SourceType,
        originalText: String,
        sentences: [TranscriptSentence],
        audioURL: URL?
    ) {
        let title = generateTitle(from: originalText)

        let note = StudyNote(
            id: UUID(),
            title: title,
            sourceType: sourceType,
            originalText: originalText,
            sentences: sentences,
            audioURL: audioURL,
            lastPlaybackPosition: 0,
            createdAt: Date()
        )

        studyNotesStore.add(note)
        showSaveConfirmation($showSavedToast)
    }
}

//#Preview {
//    SpeechToTextView()
//}
