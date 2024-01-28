//
//  SpeechService.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 25/01/2024.
//

import SwiftUI
import AVFoundation

struct SpeechState {
    var text: String = ""
    var isPlaying: Bool = false
    var wordRange: NSRange = .init()
    var progress: Double = 0.0
    
    var canPlay: Bool {
        !text.isEmpty
    }
}

@Observable
final class SpeechService: NSObject {
    static let shared = SpeechService()
    private let synthesizer = AVSpeechSynthesizer()
    
    private (set) var state: SpeechState = SpeechState()
    private (set) var isPaused: Bool = false
    private (set) var textCount: Int = 0
    
    @MainActor
    func updateText(_ text: String) {
        state.text = text
        textCount = text.count
    }
    
    @MainActor
    func pause() {
        synthesizer.pauseSpeaking(at: .immediate)
    }
    
    @MainActor
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    @MainActor
    func play() {
        if isPaused {
            synthesizer.continueSpeaking()
        } else {
            let utterance = AVSpeechUtterance(string: state.text)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            utterance.rate = 0.55
            
            synthesizer.delegate = self
            synthesizer.speak(utterance)
        }
    }
}

extension SpeechService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        state.isPlaying = true
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        self.isPaused = true
        state.isPlaying = false
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        self.isPaused = false
        state.isPlaying = true
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.isPaused = false
        state.isPlaying = false
        state.wordRange = .init()
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString: NSRange, utterance: AVSpeechUtterance) {
        let progress = Double(willSpeakRangeOfSpeechString.upperBound) / Double(state.text.count)
        state.wordRange = willSpeakRangeOfSpeechString
        state.progress = progress
    }
}
