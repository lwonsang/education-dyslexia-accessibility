//
//  TextToSpeechView.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 11/26/25.
//  Text scanning inspired by: https://youtu.be/ih67dMn7Cr0?si=ZbREYe7z5i8ixXZC

//  This is the Text To Speech View, allowing users to manually input some text, scan text using their camera, or upload text files.
//  The app will then read the text out loud in an easy to read and structured way, and users can skip ahead to desired parts or
//  press on words to open up an image bank. It can then be saved as a Study Note to be read later.

import AVFoundation
import SwiftUI
import PDFKit
internal import UIKit

struct TextToSpeechView: View {
    @StateObject private var speech = TextToSpeechViewModel()
    @EnvironmentObject var studyNotesStore: StudyNotesStore
    @EnvironmentObject var settings: AppSettings

    @State private var recognizedText = "Manually input some text or press the Start Scanning button to read your text out loud!"
    @State private var selectedRange = NSRange(location: 0, length: 0)
    @State private var pendingNote: StudyNote?
    @State private var isEditing = true
    @State private var showSavedToast = false
    @State private var selectedWord: String?
    @State private var showingWordBank = false
    @State private var showingScanningView = false
    @State private var showingHelp = false
    @State private var showingSettings = false

    var isAlreadySaved: Bool {
        studyNotesStore.containsText(recognizedText)
    }
    
    @FocusState var focusValue: Int?
    
    let buttonHeight: CGFloat = 50
    
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
                        speech.speak(from: index, rate: settings.speechRate * 0.45)
                    },
                    onWordTap: { word in
                        selectedWord = word
                        showingWordBank = true
                    }
                )
            }
            HStack(spacing: 20) {
                if isEditing {
                    Button("Start Scanning") {
                        showingScanningView = true
                    }
                    .buttonStyle(.capsuleBlue(height: buttonHeight))
                } else {
                    Button(isAlreadySaved ? "Saved ✓" : "Save to Study Notes") {
                        saveAsStudyNote()
                    }
                    .sheet(item: $pendingNote) { note in
                        SaveNoteFolderPickerView(
                            baseNote: note,
                            onSave: { finalNote in
                                studyNotesStore.add(finalNote)
                                showSaveConfirmation($showSavedToast)
                            }
                        )
                    }
                    .buttonStyle(.capsuleBlue(height: buttonHeight))
                    .disabled(isAlreadySaved)
                    .opacity(isAlreadySaved ? 0.6 : 1)
                    .modifier(SaveToastModifier(isShowing: $showSavedToast))
                }

                PlaybackControlsSection(
                    isSpeaking: speech.isSpeaking,
                    onSpeak: startSpeaking,
                    onPause: pauseSpeaking,
                    onReset: reset
                )
                .font(.title2)
                .disabled(recognizedText.isEmpty)
            }
            Spacer()
        }
        .background(settings.backgroundStyle.color)
        .ignoresSafeArea(edges: .bottom)
        .navigationBarTitle("Text To Speech Reader")
        .sheet(isPresented: $showingScanningView){
            ScanDocumentModel(recognizedText: self.$recognizedText)
        }
        .environment(\.openURL, OpenURLAction { url in
            if url.scheme == "wordbank" {
                selectedWord = url.host
                showingWordBank = true
                return .handled
            }
            return .systemAction
        })
        .overlay(alignment: .top) {
            if showSavedToast {
                SavedToast()
                    .padding(.top, 20)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut, value: showSavedToast)
        .overlay(alignment: .bottom) {
            if let word = selectedWord, showingWordBank {
                WordBankView(word: word) {
                    showingWordBank = false
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingHelp = true
                } label: {
                    Image(systemName: "questionmark.circle")
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingSettings = true
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        .sheet(isPresented: $showingSettings) {
            NavigationStack{
                SettingsView()
            }
        }
        .sheet(isPresented: $showingHelp) {
            HelpTutorialView(
                title: "Text to Speech Help",
                sections: ttsHelpSections
            )
        }
    }
    
    func startSpeaking() {
        isEditing = false
        speech.loadText(recognizedText)
        speech.speak(rate: settings.speechRate * 0.45)
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
    
    func saveAsStudyNote() {
        let title = generateTitle(from: recognizedText)
        pendingNote = StudyNote(
            id: UUID(),
            title: title,
            sourceType: .pdf,
            originalText: recognizedText,
            sentences: speech.sentences,
            audioURL: nil,
            lastPlaybackPosition: 0,
            createdAt: Date(),
            folderID: nil
        )
    }
}
