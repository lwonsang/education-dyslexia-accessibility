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
                        FilesManagementView { file in
                            audioURL = file
                        }

                        if let fileURL = audioURL {
                            Button("Transcribe Audio") {
                                Task {
                                    await assemblyai.transcribeAudio(at: fileURL)
                                }
                            }
                        }

//                        ScrollView{
//                            Text(assemblyai.transcriptText)
//                                .padding()
//                        }
                        
                        if let fileURL = audioURL {
                            if !assemblyai.transcriptText.isEmpty {
                                AudioFileTranscriptView(
                                    transcript: assemblyai.transcriptText,
                                    audioURL: fileURL
                                )
                                .frame(maxHeight: 350)
                            }
                        }
                    }
                .padding()
                }

            }
        }
    
}

#Preview {
    SpeechToTextView()
}
