//
//  AssemblyAIViewModel.swift
//  DyslexiaAccessibilityApp
//
//  Created by Wonsang Lee on 11/18/25.
//

import Foundation
internal import Combine

enum API_KEY {
    static var value: String {
        guard let key = Bundle.main.infoDictionary?["ASSEMBLYAI_API_KEY"] as? String,
              !key.isEmpty
        else {
            fatalError("ASSEMBLYAI_API_KEY not set")
        }
        return key
    }
}



@MainActor
class AssemblyAIViewModel: ObservableObject {
    @Published var transcriptText: String = ""
    @Published var isLoading = false
    @Published var sentences: [TranscriptSentence] = []

    func transcribeAudio(at fileURL: URL) async {
        do {
            isLoading = true
            sentences = []
            transcriptText = ""

            guard fileURL.startAccessingSecurityScopedResource() else {
                transcriptText = "Error: Cannot access file"
                return
            }
            defer { fileURL.stopAccessingSecurityScopedResource() }

            // 1. Upload file
            let uploadURL = try await uploadFile(url: fileURL)

            // 2. Request transcription
            let id = try await startTranscription(audioURL: uploadURL)

            // 3. Poll
            let result = try await pollTranscription(id: id)
            print("WORD COUNT:", result.words?.count ?? 0)
            print("BUILT SENTENCES:", sentences.count)

            // 4. Update UI
            transcriptText = result.text ?? "(No transcript)"
            if let words = result.words {
                self.sentences = buildSentences(from: words)
            }

        } catch {
            transcriptText = "Error: \(error.localizedDescription)"
        }

        isLoading = false
    }
}


func uploadFile(url: URL) async throws -> String {
    var request = URLRequest(url: URL(string: "https://api.assemblyai.com/v2/upload")!)
    request.httpMethod = "POST"
    request.setValue(API_KEY.value, forHTTPHeaderField: "Authorization")

    let fileData = try Data(contentsOf: url)

    let (responseData, _) = try await URLSession.shared.upload(for: request, from: fileData)

    let result = try JSONDecoder().decode(UploadResponse.self, from: responseData)
    return result.upload_url
}

struct UploadResponse: Codable {
    let upload_url: String
}

func startTranscription(audioURL: String) async throws -> String {
    let url = URL(string: "https://api.assemblyai.com/v2/transcript")!

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(API_KEY.value, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body: [String: Any] = [
        "audio_url": audioURL,
        "punctuate": true,
        "format_text": true,
        "speaker_labels": true,
        "language_detection": true
    ]

    request.httpBody = try JSONSerialization.data(withJSONObject: body)

    let (responseData, _) = try await URLSession.shared.data(for: request)
    let result = try JSONDecoder().decode(TranscriptionStart.self, from: responseData)

    return result.id
}

struct TranscriptionStart: Codable {
    let id: String
    let status: String
}

func pollTranscription(id: String) async throws -> TranscriptionResult {
    let url = URL(string: "https://api.assemblyai.com/v2/transcript/\(id)")!

    while true {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(API_KEY.value, forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(TranscriptionResult.self, from: data)

        if result.status == "completed" {
            print(result)
            return result
        } else if result.status == "error" {
            throw NSError(domain: "AssemblyAIError", code: 0, userInfo: [NSLocalizedDescriptionKey: result.error ?? "Unknown error"])
        }

        try await Task.sleep(nanoseconds: 1_000_000_000) // wait 1 second before polling again
    }
}

struct TranscriptionResult: Codable {
    let id: String
    let status: String
    let text: String?
    let error: String?
    let words: [Word]?
    
}

struct TranscriptSentence: Identifiable {
    let id = UUID()
    let text: String
    let start: TimeInterval
    let end: TimeInterval
}

func buildSentences(from words: [Word]) -> [TranscriptSentence] {
    var sentences: [TranscriptSentence] = []
    var buffer: [Word] = []

    func flush() {
        guard let first = buffer.first,
              let last = buffer.last else { return }

        let text = buffer.map { $0.text }.joined(separator: " ")

        sentences.append(
            TranscriptSentence(
                text: text,
                start: TimeInterval(first.start) / 1000,
                end: TimeInterval(last.end) / 1000
            )
        )
        buffer.removeAll()
    }

    for word in words {
        buffer.append(word)

        let endsSentence =
            word.text.hasSuffix(".") ||
            word.text.hasSuffix("?") ||
            word.text.hasSuffix("!")

        let tooLong = buffer.count >= 12   

        if endsSentence || tooLong {
            flush()
        }
    }

    flush()
    return sentences
}


struct Word: Codable {
    let text: String
    let start: Int
    let end: Int
}
