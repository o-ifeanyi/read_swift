//
//  SpeechScreen.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 28/01/2024.
//

import SwiftUI
import AVFAudio

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

struct SpeechScreen: View {
    @Environment(SpeechService.self) private var speechService
    @Binding var expanded: Bool
    
    var body: some View {
        let state = speechService.state
        NavigationView {
            VStack(spacing: 15) {
                ScrollView {
                    VStack {
                        if state.canPlay {
                            HighlightedTextView(text: state.text, highlightedRange: state.wordRange)
                                .frame(minHeight: UIScreen.height)
                        }
                    }
                }
                ProgressView(value: speechService.state.progress)
                HStack {
                    Spacer()
                    Symbols.speaker
                        .font(.title2)
                    Spacer()
                    if state.isPlaying {
                        Symbols.pause
                            .resizable()
                            .frame(width: 35, height: 35)
                            .onTapGesture {
                                speechService.pause()
                            }
                    } else {
                        Symbols.play
                            .resizable()
                            .frame(width: 35, height: 35)
                            .onTapGesture {
                                speechService.play()
                            }
                    }
                    Spacer()
                    Symbols.speed
                        .font(.title2)
                    Spacer()
                }
            }
            .padding(.horizontal, 15)
            .navigationTitle("Player")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Symbols.down
                        .onTapGesture {
                            withAnimation(.snappy(duration: 0.5)) {
                                $expanded.wrappedValue = false
                            }
                            
                        }
                }
            }
        }
    }
}
