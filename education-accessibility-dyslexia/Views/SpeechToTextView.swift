//
//  SpeechToTextView.swift
//  DyslexiaAccessibilityApp
//
//  Created by Wonsang Lee on 11/18/25.
//

import SwiftUI
internal import UniformTypeIdentifiers

struct SpeechToTextView: View {
    @StateObject private var assemblyai = AssemblyAIViewModel()
    @StateObject private var speechframework = SpeechFrameworkViewModel()
    
    @State private var audioURL: URL?
    @State private var showingFileImporter = false
    
    var body: some View {
            VStack(spacing: 30) {

                // MARK: Live Microphone Transcription
                GroupBox("Live Speech to Text (Mic)") {
                    VStack {
                        Text(speechframework.transcript)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HStack {
                            Button("Start Mic") { speechframework.start() }
                            Button("Stop") { speechframework.stop() }
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
                        }
                            
                    }
                .padding()
                }

            }
        }
    
}

//#Preview {
//    SpeechToTextView()
//}
