//
//  SpeechFrameworkViewModel.swift
//  DyslexiaAccessibilityApp
//
//  Created by Wonsang Lee on 11/19/25.
//

//  The model behind the recording of live microphone speech.

import Foundation
import SwiftUI
import AVFoundation
import Speech
internal import Combine


class SpeechFrameworkViewModel: NSObject, ObservableObject {
    @Published var transcript = ""

    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    func start() {
        SFSpeechRecognizer.requestAuthorization { auth in
            guard auth == .authorized else { return }

            DispatchQueue.main.async {
                self.startRecording()
            }
        }
    }

    func stop() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
//        recognitionTask?.cancel()
    }

    private func startRecording() {
        transcript = ""

        request = SFSpeechAudioBufferRecognitionRequest()
        request?.shouldReportPartialResults = true

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        inputNode.installTap(onBus: 0,
                             bufferSize: 1024,
                             format: recordingFormat) { buffer, _ in
            self.request?.append(buffer)
        }

        try? audioEngine.start()

        recognitionTask = speechRecognizer?.recognitionTask(with: request!) { result, error in
            if let result = result {
                DispatchQueue.main.async {
                    self.transcript = result.bestTranscription.formattedString
                }
            }
        }
    }
}

