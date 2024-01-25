//
//  SpeechService.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 25/01/2024.
//

import SwiftUI
import AVFoundation

struct SpeechState {
    var text: String? = nil
    var isPlaying: Bool = false
}

@Observable
final class SpeechService: NSObject {
    static let shared = SpeechService()
    private let synthesizer = AVSpeechSynthesizer()
    
    private (set) var state: SpeechState = SpeechState()
    private (set) var isPaused: Bool = false
    
    @MainActor
    func updateText(_ text: String) {
        state.text = text
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
        guard state.text != nil else {
            return
        }
        if isPaused {
            synthesizer.continueSpeaking()
        } else {
            let utterance = AVSpeechUtterance(string: state.text!)
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
    }
}
