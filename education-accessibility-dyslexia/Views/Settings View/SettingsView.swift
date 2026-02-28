//
//  SettingsView.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/20/26.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: AppSettings

    var body: some View {
        Form {

            Section("Speech Rate") {
                Slider(value: $settings.speechRate, in: 0.75...1.25)
            }

            Section("Reading") {
                Stepper("Font Size", value: $settings.fontSize, in: 14...30)
//                Picker("Font", selection: $settings.fontStyle) {
//                        ForEach(ReadingFont.allCases) { font in
//                            Text(font.displayName)
//                                .tag(font)
//                        }
//                    }
            }

            Section("Appearance") {
                Picker("Background", selection: $settings.backgroundStyle) {
                        ForEach(ReadingBackground.allCases) { bg in
                            Text(bg.displayName).tag(bg)
                        }
                    }
                ColorPicker("Highlight Color", selection: $settings.highlightColor)
            }
        }
        .navigationTitle(Text("Settings"))
    }
}
