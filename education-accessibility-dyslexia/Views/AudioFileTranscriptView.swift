//
//  AudioFileTranscriptView.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 12/3/25.
//

import SwiftUI

struct AudioFileTranscriptView: View {
    @StateObject var audioVM = AudioPlayerModel()

    let transcript: String  // from AssemblyAI or manual
    let audioURL: URL                  // your imported mp3 file

    var body: some View {
        VStack(alignment: .leading) {

            // Audio controls
            HStack {
                Button(audioVM.isPlaying ? "Pause" : "Play") {
                    audioVM.playPause()
                }

                Slider(value: Binding(
                    get: { audioVM.currentTime },
                    set: { audioVM.seek(to: $0) }
                ), in: 0...audioVM.duration)
            }
            .padding()

            // Transcript with word highlighting
            ScrollView {
                Text(transcript)
                    .font(.title3)
                    .padding()
                    .background(Color(white: 0.95))
                    .multilineTextAlignment(.leading)
//                    .overlay(alignment: .topLeading) {
//                        highlightedTranscriptLayer
//                    }
            }
        }
        .onAppear {
            audioVM.loadAudio(from: audioURL)
        }
    }
    
}
//#Preview {
//    AudioFileTranscriptView()
//}

