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
    
    private (set) var words: [String] = []
    private (set) var wordIndex: Int = 0
    private (set) var textCount: Int = 0
    
    @MainActor
    func initTTSVoices() {
        guard state.voices.isEmpty else { return }
        state.voices = AVSpeechSynthesisVoice.speechVoices()
    }
    
    
    @MainActor
    func updateModel(_ model: FileModel) {
        state.model = model
        switch model.type {
        case .pdf:
            let url = URL(fileURLWithPath: model.fullPath)
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
            let url = URL(fileURLWithPath: model.fullPath)
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
    }
    
    @MainActor
    func pause() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    @MainActor
    func forward() {
        synthesizer.stopSpeaking(at: .immediate)
        if wordIndex + 10 < words.count {
            wordIndex = wordIndex + 10
        } else {
            wordIndex = _words.count - 3
        }
        updateProgress()
        play()
    }
    
    @MainActor
    func rewind() {
        synthesizer.stopSpeaking(at: .immediate)
        if wordIndex - 10 > 0 {
            wordIndex = wordIndex - 10
        } else {
            wordIndex = 0
        }
        updateProgress()
        play()
    }
    
    @MainActor
    func stop() {
        wordIndex = 0
        state.progress = 0.0
        state.wordRange = .init()
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    @MainActor
    func play() {
        let spoken = state.text.index(state.text.startIndex, offsetBy: state.wordRange.lowerBound)
        let utterance = AVSpeechUtterance(string: String(state.text[spoken...]))
        initTTSVoices()
        utterance.voice = state.voices.first(where: { $0.identifier == UserDefaults.standard.value(forKey: Constants.voice) as? String}) ?? AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = UserDefaults.standard.value(forKey: Constants.speechRate) as? Float ?? 0.5
        
        synthesizer.delegate = self
        synthesizer.speak(utterance)
    }
    
    @MainActor
    func stopAndPlay() {
        synthesizer.stopSpeaking(at: .immediate)
        play()
    }
    
    private func updateProgress() {
        let utt = words[wordIndex]
        let offset = Array(_words[0 ..< wordIndex]).joined(separator: " ").count
        let spoken = state.text.index(state.text.startIndex, offsetBy: offset)
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

extension SpeechService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        state.isPlaying = true
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        state.isPlaying = false
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        state.isPlaying = true
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        state.isPlaying = false
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString: NSRange, utterance: AVSpeechUtterance) {
        
        if (wordIndex < words.count) {
            updateProgress()
        }
    }
}
