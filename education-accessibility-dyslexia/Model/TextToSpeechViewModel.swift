//
//  TextToSpeechViewModel.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/5/26.
//

import Foundation
import AVFAudio
internal import Combine
internal import UIKit

@MainActor
final class TextToSpeechViewModel: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {

    // MARK: - Published state
    @Published var isSpeaking = false
    @Published var sentences: [TranscriptSentence] = []
    @Published var currentSentenceIndex: Int?

    // MARK: - Synthesizer
    private let synthesizer = AVSpeechSynthesizer()
    
    private var lastSentenceIndex: Int?

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    // MARK: - Load text
    func loadText(_ text: String) {
        let creator = TextSentenceCreator()
        sentences = creator.createSentences(from: text)
        currentSentenceIndex = nil
    }

    // MARK: - Speak
    func speak(rate: Float) {
        guard !sentences.isEmpty else { return }

        lastSentenceIndex = sentences.count - 1
        isSpeaking = true

        for (index, sentence) in sentences.enumerated() {
            let utterance = AVSpeechUtterance(string: sentence.text)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = rate
            utterance.volume = 1.0

            // 🔑 Tag utterance with sentence index
            utterance.accessibilityHint = "\(index)"

            synthesizer.speak(utterance)
        }
    }
    
    func pause() {
        synthesizer.pauseSpeaking(at: .word)
        isSpeaking = false
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
        currentSentenceIndex = nil
    }

    // MARK: - Delegate callbacks
    func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didStart utterance: AVSpeechUtterance
    ) {
        isSpeaking = true

        if let hint = utterance.accessibilityHint,
           let index = Int(hint) {
            currentSentenceIndex = index
        }
    }

    func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didFinish utterance: AVSpeechUtterance
    ) {
        guard
            let hint = utterance.accessibilityHint,
            let index = Int(hint)
        else { return }

        if index == lastSentenceIndex {
            // ✅ Script is DONE
            isSpeaking = false
            currentSentenceIndex = nil
        }
    }

}

