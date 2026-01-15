//
//  TextCleaning.swift
//  education-accessibility-dyslexia
//
//  Created by Wonsang Lee on 1/6/26.
//

import Foundation

func cleanedTextForSpeech(_ text: String) -> String {
    let normalized = normalizeCharacters(text)
    let lineBreaksFixed = fixLineBreaks(normalized)
    let hyphensRepaired = repairHyphenation(lineBreaksFixed)
    return cleanWhitespace(hyphensRepaired)
}

func normalizeCharacters(_ text: String) -> String{
    text
        .replacingOccurrences(of: "\u{00A0}", with: " ")
}

func fixLineBreaks(_ text: String) -> String{
    text
        .replacingOccurrences(of: "\r\n", with: "\n")
        .replacingOccurrences(of: "\n\n", with: "<PARA>")
        .replacingOccurrences(of: "\n", with: " ")
        .replacingOccurrences(of: "<PARA>", with: "\n\n")
        
}

func repairHyphenation(_ text: String) -> String{
    let pattern = #"(\w+)-\s+(\p{Ll})"#
        
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return text
        }
        
        let range = NSRange(text.startIndex..., in: text)
        
        return regex.stringByReplacingMatches(
            in: text,
            options: [],
            range: range,
            withTemplate: "$1$2"
        )
        
}

func cleanWhitespace(_ text: String) -> String{
    text
        .replacingOccurrences(of: #" {2,}"#, with: " ", options: .regularExpression)
        .replacingOccurrences(of: #"\n{3,}"#, with: "\n\n", options: .regularExpression)
        .trimmingCharacters(in: .whitespacesAndNewlines)
        
}
