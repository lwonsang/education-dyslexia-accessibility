//
//  FilesManagementView.swift
//  DyslexiaAccessibilityApp
//
//  Created by Wonsang Lee on 11/18/25.
//

import SwiftUI
internal import UniformTypeIdentifiers

struct FilesManagementView: View {
    @State private var importing = false
    var onFileImported: (URL) -> Void
    
    var body: some View {
        Button("Import") {
            importing = true
        }
        .fileImporter(
            isPresented: $importing,
            allowedContentTypes: [.audio]
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
