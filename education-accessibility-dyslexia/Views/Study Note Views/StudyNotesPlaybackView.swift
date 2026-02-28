//
//  StudyNotesPlaybackView.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 2/4/26.
//

// This view allows the user to play different audio files that correspond to certain study notes.

import SwiftUI

struct StudyNotesPlaybackView: View {
    let sentences: [TranscriptSentence]
    let audioURL: URL

    @EnvironmentObject var settings: AppSettings
    @StateObject private var audioVM = AudioPlayerModel()

    var body: some View {
        
        // MARK: Playback controls
        HStack {
            Button(audioVM.isPlaying ? "Pause" : "Play") {
                audioVM.playPause(rate: settings.speechRate)
            }

            Slider(
                value: Binding(
                    get: { audioVM.currentTime },
                    set: { audioVM.seek(to: $0) }
                ),
                in: 0...audioVM.duration
            )
        }
        .padding(.horizontal)
        .onAppear {
            audioVM.loadAudio(from: audioURL)
        }
        .onDisappear {
            audioVM.stop()
        }
    }

    private func isCurrent(_ sentence: TranscriptSentence) -> Bool {
        guard let start = sentence.start, let end = sentence.end else { return false }
        return audioVM.currentTime >= start && audioVM.currentTime < end
    }

    private func scrollToCurrentSentence(_ proxy: ScrollViewProxy) {
        guard let active = sentences.first(where: isCurrent) else { return }
        withAnimation(.easeInOut(duration: 0.25)) {
            proxy.scrollTo(active.id, anchor: .center)
        }
    }
}

