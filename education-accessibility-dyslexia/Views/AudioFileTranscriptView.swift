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
                                Text(sentence.text)
                                    .padding(8)
                                    .background(
                                        isCurrent(sentence)
                                            ? Color.yellow.opacity(0.4)
                                            : Color.clear
                                    )
                                    .cornerRadius(6)
                                    .id(sentence.id)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: audioVM.currentTime) { _ in
                        scrollToCurrentSentence(proxy)
                    }
                }
            }
        }
        .onAppear {
            audioVM.loadAudio(from: audioURL)
        }
    }

    func isCurrent(_ sentence: TranscriptSentence) -> Bool {
        audioVM.currentTime >= sentence.start &&
        audioVM.currentTime < sentence.end
    }

    func scrollToCurrentSentence(_ proxy: ScrollViewProxy) {
        guard let active = assemblyai.sentences.first(where: {
            audioVM.currentTime >= $0.start &&
            audioVM.currentTime < $0.end
        }) else { return }

        withAnimation(.easeInOut(duration: 0.3)) {
            proxy.scrollTo(active.id, anchor: .center)
        }
    }
}

//#Preview {
//    AudioFileTranscriptView()
//}

