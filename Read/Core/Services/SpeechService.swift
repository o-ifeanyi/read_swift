//
//  SpeechService.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 25/01/2024.
//

import SwiftUI
import AVFoundation
import PDFKit

struct SpeechState {
    var text: String = ""
    var model: FileModel? = nil
    var isPlaying: Bool = false
    var wordRange: NSRange = .init()
    var progress: Double = 0.0
    var voices: [AVSpeechSynthesisVoice] = []
    
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
    
    private (set) var words: [String] = []
    private (set) var wordIndex: Int = 0
    private (set) var textCount: Int = 0
    
    @MainActor
    func updateModel(_ model: FileModel) {
        state.model = model
        switch model.type {
        case .pdf:
            guard let url = URL(string: model.path) else {
                return
            }
            if let pdf = PDFDocument(url: url) {
                TextParser.parsePdf(pdf: pdf, perform: { result in
                    self.stop()
                    self.state.text = result
                    self.words = self.state.text.split(separator: " ").map( { "\($0)" })
                    self.textCount = self.state.text.count
                    self.play()
                })
            } else {
                print("document not found")
            }
        case .image:
            guard let url = URL(string: model.path) else {
                return
            }
            do {
                let imageData = try Data.init(contentsOf: url)
                let image = UIImage(data: imageData)
                TextParser.parseImage(image: image, perform: { result in
                    self.stop()
                    self.state.text  = result
                    self.words = self.state.text.split(separator: " ").map( { "\($0)" })
                    self.textCount = self.state.text.count
                    self.play()
                })
            } catch {
                print(error.localizedDescription)
            }
        case .url:
            TextParser.parseUrl(link: model.path, perform: { result in
                self.stop()
                self.state.text = result
                self.words = self.state.text.split(separator: " ").map( { "\($0)" })
                self.textCount = self.state.text.count
                self.play()
            })
        }
        if state.voices.isEmpty {
            state.voices = AVSpeechSynthesisVoice.speechVoices()
        }
    }
    
    @MainActor
    func pause() {
        synthesizer.pauseSpeaking(at: .immediate)
    }
    
    @MainActor
    func stop() {
        wordIndex = 0
        state.progress = 0.0
        state.wordRange = .init()
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    @MainActor
    func play(voice: AVSpeechSynthesisVoice? = nil, rate: Float? = nil) {
        if isPaused {
            synthesizer.continueSpeaking()
        } else {
            let spoken = state.text.index(state.text.startIndex, offsetBy: state.wordRange.lowerBound)
            let utterance = AVSpeechUtterance(string: String(state.text[spoken...]))
            utterance.voice = voice ?? AVSpeechSynthesisVoice(language: "en-GB")
            utterance.rate = rate ?? 0.5
            
            synthesizer.delegate = self
            synthesizer.speak(utterance)
        }
    }
    
    
    @MainActor
    func changeVoice(voice: AVSpeechSynthesisVoice) {
        synthesizer.stopSpeaking(at: .immediate)
        play(voice: voice)
    }
    
    @MainActor
    func changeRate(rate: Float) {
        synthesizer.stopSpeaking(at: .immediate)
        play(rate: rate)
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
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString: NSRange, utterance: AVSpeechUtterance) {
        
        if (wordIndex < words.count) {
            let utt = words[wordIndex]
            let spoken = state.text.index(state.text.startIndex, offsetBy: state.wordRange.lowerBound)
            guard let range = state.text.range(of: utt, options: .caseInsensitive, range: spoken ..< state.text.endIndex) else {
                return
            }
            wordIndex += 1
            let startIndex = state.text.distance(from: state.text.startIndex, to: range.lowerBound)
            let endIndex = state.text.distance(from: state.text.startIndex, to: range.upperBound)
            if endIndex > startIndex {
                let progress = Double(endIndex) / Double(textCount)
                
                state.wordRange = NSRange(location: startIndex, length: endIndex - startIndex)
                state.progress = progress
            }
        }
    }
}
