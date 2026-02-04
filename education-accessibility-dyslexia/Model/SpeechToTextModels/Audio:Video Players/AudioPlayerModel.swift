//
//  AudioPlayerModel.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 12/3/25.
//

//  The model behind the audio player.

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
        let needsSecurityAccess = !url.path.contains(
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        )

        let didStartAccessing = needsSecurityAccess
            ? url.startAccessingSecurityScopedResource()
            : false

        defer {
            if didStartAccessing {
                url.stopAccessingSecurityScopedResource()
            }
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.enableRate = true
            player?.prepareToPlay()

            duration = player?.duration ?? 0
            currentTime = 0

            startTimer()
        } catch {
            print("ERROR loading audio:", error)
        }
    }


    func playPause(rate: Float) {
        guard let player = player else { return }

        if player.isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.rate = rate
            player.play()
            print("Playback rate from playPause:", rate)
            isPlaying = true
        }
    }
    
    func play(from time: TimeInterval, rate: Float) {
        guard let player = player else { return }

        player.currentTime = time
        player.play()
        player.rate = rate
        print("Playback rate from play:", rate)
        isPlaying = true
    }

    func seek(to time: TimeInterval) {
        player?.currentTime = time
        currentTime = time
    }
    
    func stop() {
        player?.stop()
        player?.currentTime = 0
        player = nil
        isPlaying = false
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
