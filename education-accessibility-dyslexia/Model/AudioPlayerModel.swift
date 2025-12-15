//
//  AudioPlayerModel.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 12/3/25.
//

import Foundation
import AVFoundation
internal import Combine

class AudioPlayerModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    
    private var timer: Timer?
    private var player: AVAudioPlayer?
    
    func loadAudio(from url: URL) {
        guard url.startAccessingSecurityScopedResource() else {
            print("ERROR: Cannot access audio file")
            return
        }

        defer { url.stopAccessingSecurityScopedResource() }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.prepareToPlay()

            duration = player?.duration ?? 0
            currentTime = 0

            startTimer()
        } catch {
            print("ERROR loading audio:", error.localizedDescription)
        }
    }

    func playPause() {
        guard let player = player else { return }

        if player.isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }

    func seek(to time: TimeInterval) {
        player?.currentTime = time
        currentTime = time
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            guard let player = self.player else { return }
            self.currentTime = player.currentTime
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
}
