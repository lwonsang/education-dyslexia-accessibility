//
//  FilesManagementView.swift
//  DyslexiaAccessibilityApp
//
//  Created by Wonsang Lee on 11/18/25.
//

import SwiftUI
internal import UniformTypeIdentifiers

enum FileImportMode {
    case audio
    case text

    var buttonTitle: String {
        switch self {
        case .audio:
            return "Import Audio File"
        case .text:
            return "Import Text File"
        }
    }

    var allowedContentTypes: [UTType] {
        switch self {
        case .audio:
            return [.audio]
        case .text:
            return [.plainText, .pdf]
        }
    }
}

struct FilesManagementView: View {
    let mode: FileImportMode
    
    @State private var importing = false
    var onFileImported: (URL) -> Void
    
    var body: some View {
        Button(mode.buttonTitle) {
            importing = true
        }
        .fileImporter(
            isPresented: $importing,
            allowedContentTypes: mode.allowedContentTypes
        ) { result in
            switch result {
            case .success(let url):
                if url.startAccessingSecurityScopedResource() {
                    defer { url.stopAccessingSecurityScopedResource() }
                    onFileImported(url)
                } else {
                    print("Unable to access security-scoped resource.")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//#Preview {
//    FilesManagementView()
//}
