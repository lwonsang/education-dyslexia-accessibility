//
//  NavigationView.swift
//  DyslexiaAccessibilityApp
//
//  Created by Wonsang Lee on 11/18/25.
//

import SwiftUI

struct Navigation2View: View {
    @State private var selection: Tab = .textToSpeech
    enum Tab{
        case textToSpeech
        case speechToText
    }
    
    var body : some View{
        TabView(selection: $selection){
            TextToSpeechView()
                .tabItem{
                    Label("TextToSpeech", systemImage: "star")
                }
                .tag(Tab.textToSpeech)
            SpeechToTextView()
                .tabItem{
                    Label( "SpeechToText", systemImage: "star")
                }
                .tag(Tab.speechToText)
        }
    }
}

#Preview {
    Navigation2View()
}
