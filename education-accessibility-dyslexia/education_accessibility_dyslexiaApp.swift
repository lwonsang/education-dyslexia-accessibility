//
//  education_accessibility_dyslexiaApp.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 11/22/25.
//

import SwiftUI

@main
struct education_accessibility_dyslexiaApp: App {
    @StateObject private var studyNotesStore = StudyNotesStore()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(studyNotesStore)
        }
    }
}
