//
//  STTToolbarModifier.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 2/3/26.
//


import SwiftUI

struct STTToolbarModifier: ViewModifier {
    @Binding var showingHelp: Bool
    @Binding var showingSettings: Bool

    func body(content: Content) -> some View {
        content
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
    }
}
