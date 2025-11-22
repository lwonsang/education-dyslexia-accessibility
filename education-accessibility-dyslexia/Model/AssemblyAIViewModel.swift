//
//  AssemblyAIViewModel.swift
//  DyslexiaAccessibilityApp
//
//  Created by Wonsang Lee on 11/18/25.
//

import Foundation
internal import Combine

let API_KEY = "eeff8806418c4922868815896fb19c06"

@MainActor
class AssemblyAIViewModel: ObservableObject {
    @Published var transcriptText: String = ""
    @Published var isLoading = false

    func transcribeAudio(at fileURL: URL) async {
        do {
            isLoading = true

            // MUST request access again here
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

            // 4. Update UI
            transcriptText = result.text ?? "(No transcript)"
        } catch {
            transcriptText = "Error: \(error.localizedDescription)"
        }

        isLoading = false
    }
}


func uploadFile(url: URL) async throws -> String {
    var request = URLRequest(url: URL(string: "https://api.assemblyai.com/v2/upload")!)
    request.httpMethod = "POST"
    request.setValue(API_KEY, forHTTPHeaderField: "Authorization")

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
    request.setValue(API_KEY, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body: [String: Any] = [
        "audio_url": audioURL
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
        request.setValue(API_KEY, forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(TranscriptionResult.self, from: data)

        if result.status == "completed" {
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
}
