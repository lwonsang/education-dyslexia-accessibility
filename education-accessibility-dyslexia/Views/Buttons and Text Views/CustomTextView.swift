//
//  CustomTextView.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/5/26.
//

//  CustomTextView allows users to edit text, is used in TextInputSection along with FilesManagementView.

import SwiftUI
internal import UIKit

struct CustomTextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var selectedRange: NSRange

    var isEditable: Bool = true
    var fontSize: CGFloat = 18
    var lineSpacing: CGFloat = 6
    var letterSpacing: CGFloat = 0.5

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator

        textView.isEditable = isEditable
        textView.isSelectable = true
        textView.isScrollEnabled = true
        textView.backgroundColor = .clear

        textView.font = .systemFont(ofSize: fontSize)
        textView.textContainerInset = UIEdgeInsets(
            top: 12,
            left: 8,
            bottom: 12,
            right: 8
        )

        applyTextStyle(to: textView)

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        applyTextStyle(to: uiView)
    }

    func applyTextStyle(to textView: UITextView) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize),
            .kern: letterSpacing,
            .paragraphStyle: paragraphStyle
        ]

        textView.typingAttributes = attributes
        textView.attributedText = NSAttributedString(string: textView.text, attributes: attributes)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        let parent: CustomTextView

        init(_ parent: CustomTextView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }

        func textViewDidChangeSelection(_ textView: UITextView) {
            parent.selectedRange = textView.selectedRange
        }
    }
}



//#Preview {
//    CustomTextView()
//}
