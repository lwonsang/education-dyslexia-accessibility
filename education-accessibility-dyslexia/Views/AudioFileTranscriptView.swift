//
//  AudioFileTranscriptView.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 12/3/25.
//

import SwiftUI

struct AudioFileTranscriptView: View {
    @ObservedObject var assemblyai: AssemblyAIViewModel
    @StateObject var audioVM = AudioPlayerModel()
    
    @State private var selectedWord: String?
    @State private var showingWordBank = false
    
    let audioURL: URL

    var body: some View {
        VStack(alignment: .leading) {

            HStack {
                Button(audioVM.isPlaying ? "Pause" : "Play") {
                    audioVM.playPause()
                }

                Slider(
                    value: Binding(
                        get: { audioVM.currentTime },
                        set: { audioVM.seek(to: $0) }
                    ),
                    in: 0...audioVM.duration
                )
            }
            .padding()

            if assemblyai.sentences.isEmpty {
                Text("Transcribing…")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(assemblyai.sentences) { sentence in
                                TranscriptSentenceView(
                                    sentence: sentence,
                                    isCurrent: isCurrent(sentence)
                                ) { word in
                                    selectedWord = word
                                    showingWordBank = true
                                }
                                .id(sentence.id)
                            }
                        }
                        .padding()
                    }
                    .environment(\.openURL, OpenURLAction { url in
                        if url.scheme == "wordbank" {
                            selectedWord = url.host
                            showingWordBank = true
                            return .handled
                        }
                        return .systemAction
                    })
                    .onChange(of: audioVM.currentTime) { _ in
                        scrollToCurrentSentence(proxy)
                    }
                }


                
            }
        }
        .onAppear {
            audioVM.loadAudio(from: audioURL)
        }
        .overlay(alignment: .bottom) {
            if let word = selectedWord, showingWordBank {
                WordBankView(word: word) {
                    showingWordBank = false
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .padding()
            }
        }
    }

    func isCurrent(_ sentence: TranscriptSentence) -> Bool {
        audioVM.currentTime >= sentence.start! &&
        audioVM.currentTime < sentence.end!
    }

    func scrollToCurrentSentence(_ proxy: ScrollViewProxy) {
        guard let active = assemblyai.sentences.first(where: {
            audioVM.currentTime >= $0.start! &&
            audioVM.currentTime < $0.end!
        }) else { return }

        withAnimation(.easeInOut(duration: 0.3)) {
            proxy.scrollTo(active.id, anchor: .center)
        }
    }
    
    
}

//#Preview {
//    AudioFileTranscriptView()
//}

