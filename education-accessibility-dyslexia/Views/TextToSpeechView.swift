//
//  TextToSpeechView.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 11/26/25.
//  Inspired by: https://youtu.be/ih67dMn7Cr0?si=ZbREYe7z5i8ixXZC

import AVFoundation
import SwiftUI
import PDFKit
internal import UIKit

struct TextToSpeechView: View {
    @StateObject private var speech = TextToSpeechViewModel()

    @State private var recognizedText = "Manually input some text or press the Start Scanning button to read your text out loud!"
    @State private var selectedRange = NSRange(location: 0, length: 0)
    @State private var isEditing = true

    @State private var selectedWord: String?
    @State private var showingWordBank = false
    @State private var showingScanningView = false


    @FocusState var focusValue: Int?
    
    let buttonHeight: CGFloat = 50
    let rate: Float = 0.45
    
    var body: some View {
        VStack(spacing: 16) {

            if isEditing {
                TextInputSection(
                    text: $recognizedText,
                    selectedRange: $selectedRange,
                    onImportFile: loadTextFromFile
                )
            } else {
                SentencePlaybackSection(
                    sentences: speech.sentences,
                    currentSentenceIndex: speech.currentSentenceIndex,
                    onSentenceTap: { index in
                        speech.speak(from: index, rate: rate)
                    },
                    onWordTap: { word in
                        selectedWord = word
                        showingWordBank = true
                    }
                )
            }
            HStack(spacing: 20){
                Button(action: {
                    self.showingScanningView = true
                }){
                    Text("Start Scanning")
                        .frame(maxWidth: .infinity, minHeight: buttonHeight)
                        .padding()
                        .foregroundColor(.white)
                        .background(Capsule().fill(.blue))
                }
                .padding()

                PlaybackControlsSection(
                    isSpeaking: speech.isSpeaking,
                    onSpeak: startSpeaking,
                    onPause: pauseSpeaking,
                    onReset: reset
                )
                    .font(.title2)
                    .disabled(recognizedText == "Tap button to start scanning")
                }
                    .background(.gray.opacity(0.1))
                    .navigationBarTitle("Text To Speech Reader")
                    .sheet(isPresented: $showingScanningView){
                        ScanDocumentModel(recognizedText: self.$recognizedText)
                    }
            }
            .environment(\.openURL, OpenURLAction { url in
                if url.scheme == "wordbank" {
                    selectedWord = url.host
                    showingWordBank = true
                    return .handled
                }
                return .systemAction
            })
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
    
    func startSpeaking() {
        isEditing = false
        speech.loadText(recognizedText)
        speech.speak(rate: 0.45)
    }

    func pauseSpeaking() {
        speech.pause()
    }

    func reset() {
        speech.stop()
        isEditing = true
        recognizedText = ""
    }

    
    func extractTextFromPDF(_ url: URL) ->String {
        guard let pdf = PDFDocument(url: url) else { return "" }
        
        return (0..<pdf.pageCount)
            .compactMap { pdf.page(at: $0)?.string }
            .joined(separator: "\n")
    }
    
    func loadPlainText(_ url: URL) {
        do {
            recognizedText = try String(contentsOf: url, encoding: .utf8)
        } catch {
            recognizedText = "Failed to read text file."
        }
    }
    
    func loadTextFromFile(_ url: URL) {
        guard let pdf = PDFDocument(url: url) else { return }

        let rawText = (0..<pdf.pageCount)
            .compactMap { pdf.page(at: $0)?.string }
            .joined(separator: "\n\n")

        recognizedText = cleanedTextForSpeech(rawText)
    }
    
    func cleanedTextForSpeech(_ text: String) -> String {
        let normalized = normalizeCharacters(text)
        let lineBreaksFixed = fixLineBreaks(normalized)
        let hyphensRepaired = repairHyphenation(lineBreaksFixed)
        return cleanWhitespace(hyphensRepaired)
    }
    
    func normalizeCharacters(_ text: String) -> String{
        text
            .replacingOccurrences(of: "\u{00A0}", with: " ")
    }
    
    func fixLineBreaks(_ text: String) -> String{
        text
            .replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "\n\n", with: "<PARA>")
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "<PARA>", with: "\n\n")
            
    }
    
    func repairHyphenation(_ text: String) -> String{
        let pattern = #"(\w+)-\s+(\p{Ll})"#
            
            guard let regex = try? NSRegularExpression(pattern: pattern) else {
                return text
            }
            
            let range = NSRange(text.startIndex..., in: text)
            
            return regex.stringByReplacingMatches(
                in: text,
                options: [],
                range: range,
                withTemplate: "$1$2"
            )
            
    }
    
    func cleanWhitespace(_ text: String) -> String{
        text
            .replacingOccurrences(of: #" {2,}"#, with: " ", options: .regularExpression)
            .replacingOccurrences(of: #"\n{3,}"#, with: "\n\n", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            
    }

}

//
//struct TextToSpeechView: View {
//    @StateObject private var speech = TextToSpeechViewModel()
//    @State private var recognizedText = "Manually input some text or press the Start Scanning button to read your text out loud!"
//    @State private var rate = Float(0.45)
//    @State private var showingScanningView = false
//    @State private var selectedRange = NSRange(location: 0, length: 0)
//    @State private var currentSentenceIndex: Int? = nil
//    @State private var isEditing = true
//    @State private var selectedWord: String?
//    @State private var showingWordBank = false
//
//    @FocusState var focusValue: Int?
//    
//    let buttonHeight: CGFloat = 50
//    
//    var body: some View{
//        NavigationView{
//            VStack{
//                ScrollViewReader { proxy in
//                    ScrollView {
//                        VStack(spacing: 12) {
//
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 20, style: .continuous)
//                                    .fill(.white)
//                                    .shadow(radius: 3)
//
//                                if isEditing {
//                                    CustomTextView(
//                                        text: $recognizedText,
//                                        selectedRange: $selectedRange
//                                    )
//                                    .frame(height: 150)
//                                } else {
//                                    VStack(alignment: .leading, spacing: 12) {
//                                        ForEach(speech.sentences) { sentence in
//                                            TranscriptSentenceView(
//                                                sentence: sentence,
//                                                isCurrent: sentence.id == speech.currentSentenceIndex,
//                                                onWordTap: { word in
//                                                    print("Tapped:", word)
//                                                }
//                                            ) { word in
//                                                selectedWord = word
//                                                showingWordBank = true
//                                            }
//                                            .id(index) // 🔑 REQUIRED
//                                        }
//                                    }
//                                    .padding()
//                                }
//                            }
//
//                            FilesManagementView(mode: .text) { textURL in
//                                loadTextFromFile(textURL)
//                            }
//                        }
//                        .padding()
//                    }
//                    .environment(\.openURL, OpenURLAction { url in
//                        if url.scheme == "wordbank" {
//                            selectedWord = url.host
//                            showingWordBank = true
//                            return .handled
//                        }
//                        return .systemAction
//                    })
//                    .onChange(of: speech.currentSentenceIndex) { index in
//                        guard let index else { return }
//
//                        DispatchQueue.main.async {
//                            withAnimation {
//                                proxy.scrollTo(index, anchor: .center)
//                            }
//                        }
//                    }
//                }
//                Spacer()
//                HStack(spacing: 20){
//                    Button(action: {
//                        self.showingScanningView = true
//                    }){
//                        Text("Start Scanning")
//                            .frame(maxWidth: .infinity, minHeight: buttonHeight)
//                            .padding()
//                            .foregroundColor(.white)
//                            .background(Capsule().fill(.blue))
//                    }
//                    
//                    HStack {
//                        Button(speech.isSpeaking ? "Stop" : "Speak") {
//                            if speech.isSpeaking{
//                                speech.pause()
//                                isEditing = true
//                            }
//                            else{
//                                isEditing = false
//                                speech.loadText(recognizedText)
//                                speech.speak(rate: rate)
//                            }
//                        }
//
//                        Button("Reset") {
//                            speech.stop()
//                            isEditing = true
//                            recognizedText = ""
//                        }
//                    }
//                    .font(.title2)
//                    .padding()
//                    .disabled(recognizedText == "Tap button to start scanning")
//                }
//                .padding()
//            }
//            .background(.gray.opacity(0.1))
//            .navigationBarTitle("Text To Speech Reader")
//            .sheet(isPresented: $showingScanningView){
//                ScanDocumentModel(recognizedText: self.$recognizedText)
//            }
//            
//        }
//    }
//    
//    func extractTextFromPDF(_ url: URL) ->String {
//        guard let pdf = PDFDocument(url: url) else { return "" }
//        
//        return (0..<pdf.pageCount)
//            .compactMap { pdf.page(at: $0)?.string }
//            .joined(separator: "\n")
//    }
//    
//    func loadPlainText(_ url: URL) {
//        do {
//            recognizedText = try String(contentsOf: url, encoding: .utf8)
//        } catch {
//            recognizedText = "Failed to read text file."
//        }
//    }
//    
//    func loadTextFromFile(_ url: URL) {
//        guard let pdf = PDFDocument(url: url) else { return }
//
//        let rawText = (0..<pdf.pageCount)
//            .compactMap { pdf.page(at: $0)?.string }
//            .joined(separator: "\n\n")
//
//        recognizedText = cleanedTextForSpeech(rawText)
//    }
//    
//    func cleanedTextForSpeech(_ text: String) -> String {
//        let normalized = normalizeCharacters(text)
//        let lineBreaksFixed = fixLineBreaks(normalized)
//        let hyphensRepaired = repairHyphenation(lineBreaksFixed)
//        return cleanWhitespace(hyphensRepaired)
//    }
//    
//    func normalizeCharacters(_ text: String) -> String{
//        text
//            .replacingOccurrences(of: "\u{00A0}", with: " ")
//    }
//    
//    func fixLineBreaks(_ text: String) -> String{
//        text
//            .replacingOccurrences(of: "\r\n", with: "\n")
//            .replacingOccurrences(of: "\n\n", with: "<PARA>")
//            .replacingOccurrences(of: "\n", with: " ")
//            .replacingOccurrences(of: "<PARA>", with: "\n\n")
//            
//    }
//    
//    func repairHyphenation(_ text: String) -> String{
//        let pattern = #"(\w+)-\s+(\p{Ll})"#
//            
//            guard let regex = try? NSRegularExpression(pattern: pattern) else {
//                return text
//            }
//            
//            let range = NSRange(text.startIndex..., in: text)
//            
//            return regex.stringByReplacingMatches(
//                in: text,
//                options: [],
//                range: range,
//                withTemplate: "$1$2"
//            )
//            
//    }
//    
//    func cleanWhitespace(_ text: String) -> String{
//        text
//            .replacingOccurrences(of: #" {2,}"#, with: " ", options: .regularExpression)
//            .replacingOccurrences(of: #"\n{3,}"#, with: "\n\n", options: .regularExpression)
//            .trimmingCharacters(in: .whitespacesAndNewlines)
//            
//    }
//
//}
//#Preview {
//    TextToSpeechView()
//}
