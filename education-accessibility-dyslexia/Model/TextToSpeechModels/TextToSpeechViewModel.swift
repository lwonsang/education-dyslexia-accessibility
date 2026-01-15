//
//  TextToSpeechViewModel.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/5/26.
//

//  The model behind the TextToSpeechView.

import Foundation
import AVFAudio
internal import Combine
internal import UIKit

@MainActor
final class TextToSpeechViewModel: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    @Published var isSpeaking = false
    @Published var sentences: [TranscriptSentence] = []
    @Published var currentSentenceIndex: Int?

    private let synthesizer = AVSpeechSynthesizer()
    
    private var lastSentenceIndex: Int?

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func loadText(_ text: String) {
        let creator = TextSentenceCreator()
        sentences = creator.createSentences(from: text)
        currentSentenceIndex = nil
    }

    func speak(rate: Float) {
        guard !sentences.isEmpty else { return }

        lastSentenceIndex = sentences.count - 1
        isSpeaking = true

        for (index, sentence) in sentences.enumerated() {
            let utterance = AVSpeechUtterance(string: sentence.text)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = rate
            utterance.volume = 1.0

            utterance.accessibilityHint = "\(index)"

            synthesizer.speak(utterance)
        }
    }
    
    func speak(from index: Int, rate: Float) {
        guard index < sentences.count else { return }

        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = true

        for i in index..<sentences.count {
            let sentence = sentences[i]

            let utterance = AVSpeechUtterance(string: sentence.text)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = rate
            utterance.volume = 1.0
            utterance.accessibilityHint = "\(i)"

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
            isSpeaking = false
            currentSentenceIndex = nil
        }
    }

}

