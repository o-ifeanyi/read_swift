//
//  HighlightedTextView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 01/02/2024.
//

import SwiftUI

struct HighlightedTextView: UIViewRepresentable {
    @Environment(\.colorScheme) var theme
    var text: String
    var highlightedRange: NSRange
    
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        textView.attributedText = attributedText()
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedText()
    }
    
    func attributedText() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        // color for all text in light & dark mode
        attributedString.addAttribute(.foregroundColor, value: theme == .dark ? UIColor.white : UIColor.black, range: NSRange(location: 0, length: text.count))
        // bg color of highlighted text
        attributedString.addAttribute(.backgroundColor, value: UIColor.cyan, range: highlightedRange)
        // fg color of highlighted text
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: highlightedRange)
        // font for all text
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18), range: NSRange(location: 0, length: text.count))
        // color for read text
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 0, length: highlightedRange.location))
        
        return attributedString
    }
}
