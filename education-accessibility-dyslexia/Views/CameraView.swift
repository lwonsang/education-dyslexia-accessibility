//
//  CameraView.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 11/26/25.
//  Inspired by: https://youtu.be/ih67dMn7Cr0?si=ZbREYe7z5i8ixXZC

import AVFoundation
import SwiftUI

struct CameraView: View {
    @StateObject private var speech = SpeechViewModel()
    @State private var recognizedText = "This app can help students with dyslexia by reading text aloud."
    @State private var rate = Float(0.45)
    @State private var showingScanningView = false
    let buttonHeight: CGFloat = 50
    
    var body: some View{
        NavigationView{
            VStack{
                ScrollView{
                    ZStack{
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(.white)
                            .shadow(radius: 3)
                        Text(recognizedText)
                            .padding()
                    }
                    .padding()
                }
                Spacer()
                HStack(spacing: 20){
                    Button(action: {
                        self.showingScanningView = true
                    }){
                        Text("Start Scaning")
                            .frame(maxWidth: .infinity, minHeight: buttonHeight)
                            .padding()
                            .foregroundColor(.white)
                            .background(Capsule().fill(.blue))
                    }
                    
                    Button(speech.isSpeaking ? "Stop" : "Speak") {
                        if speech.isSpeaking {
                            speech.stop()
                        } else {
                            speech.speak(recognizedText, rate: rate)
                        }
                    }
                    .font(.title2)
                    .padding()
                    .disabled(recognizedText == "Tap button to start scanning")
                }
                .padding()
            }
            .background(.gray.opacity(0.1))
            .navigationBarTitle("Document Scanner")
            .sheet(isPresented: $showingScanningView){
                ScanDocumentModel(recognizedText: self.$recognizedText)
            }
        }
    }
}
//#Preview {
//    CameraView()
//}
