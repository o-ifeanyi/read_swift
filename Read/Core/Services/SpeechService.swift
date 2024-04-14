//
//  SpeechService.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 25/01/2024.
//

import AVFoundation

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
    func initSpeechService() {
        guard state.voices.isEmpty else { return }
        state.voices = AVSpeechSynthesisVoice.speechVoices()
    }
    
    
    @MainActor
    func updateModel(_ model: FileModel, callBack: (() -> Void)? = nil) {
        state.model = model
        switch model.type {
        case .pdf:
            let url = URL(fileURLWithPath: model.fullPath)
            TextParser.parsePdf(url: url, page: model.currentPage, perform: { result, pageCount, error in
                self.stop()
                self.state.text = result
                self.words = self.state.text.split(separator: " ").map( { "\($0)" })
                self.wordIndex = model.wordIndex
                self.textCount = self.state.text.count
                self.play()
                if error == nil {
                    model.totalPages = pageCount
                    callBack?()
                    AnalyticService.shared.track(event: "play_doc")
                }
            })
        case .img:
            if let cached = model.readCache() {
                self.stop()
                self.state.text  = cached
                self.words = self.state.text.split(separator: " ").map( { "\($0)" })
                self.wordIndex = model.wordIndex
                self.textCount = self.state.text.count
                self.play()
                AnalyticService.shared.track(event: "play_image_cache")
            } else {
                AppStateService.shared.displayLoader()
                let url = URL(fileURLWithPath: model.fullPath)
                TextParser.parseImage(url: url, perform: { result, generated, error in
                    self.stop()
                    self.state.text  = result
                    self.words = self.state.text.split(separator: " ").map( { "\($0)" })
                    self.wordIndex = model.wordIndex
                    self.textCount = self.state.text.count
                    self.play()
                    if error == nil {
                        if generated == true {
                            model.writeCache(text: result)
                        }
                        callBack?()
                        AnalyticService.shared.track(event: "play_image")
                    }
                    AppStateService.shared.removeLoader()
                })
            }
        case .txt:
            let url = URL(fileURLWithPath: model.fullPath)
            TextParser.parseText(url: url, perform: { result, error in
                self.stop()
                self.state.text  = result
                self.words = self.state.text.split(separator: " ").map( { "\($0)" })
                self.wordIndex = model.wordIndex
                self.textCount = self.state.text.count
                self.play()
                if error == nil {
                    callBack?()
                    AnalyticService.shared.track(event: "play_text")
                }
            })
        case .url:
            if let cached = model.readCache() {
                self.stop()
                self.state.text  = cached
                self.words = self.state.text.split(separator: " ").map( { "\($0)" })
                self.wordIndex = model.wordIndex
                self.textCount = self.state.text.count
                self.play()
                AnalyticService.shared.track(event: "play_url_cache")
            } else {
                AppStateService.shared.displayLoader()
                TextParser.parseUrl(link: model.path, perform: { result, error in
                    self.stop()
                    self.state.text = result
                    self.words = self.state.text.split(separator: " ").map( { "\($0)" })
                    self.wordIndex = model.wordIndex
                    self.textCount = self.state.text.count
                    self.play()
                    if error == nil {
                        AnalyticService.shared.track(event: "play_url")
                        model.writeCache(text: result)
                        callBack?()
                    }
                    AppStateService.shared.removeLoader()
                })
            }
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
    func stop(_ reset: Bool = false) {
        wordIndex = 0
        state.progress = 0.0
        state.wordRange = .init()
        synthesizer.stopSpeaking(at: .immediate)
        
        if reset {
            state.text = ""
            state.model = nil
        }
    }
    
    
    @MainActor
    func nextPage() {
        guard state.model != nil else { return }
        guard state.model!.currentPage + 1 <= state.model!.totalPages else { return }
        stop()
        state.model!.currentPage = state.model!.currentPage + 1
        state.model!.wordIndex = 0
        state.model!.wordRange = []
        updateModel(state.model!)
    }
    
    
    @MainActor
    func prevPage() {
        guard state.model != nil else { return }
        guard state.model!.currentPage - 1 >= 1 else { return }
        stop()
        state.model!.currentPage = state.model!.currentPage - 1
        state.model!.wordIndex = 0
        state.model!.wordRange = []
        updateModel(state.model!)
    }
    
    
    @MainActor
    func goToPage(page: Int) {
        guard state.model != nil else { return }
        guard page > 0 && page <= state.model!.totalPages else { return }
        stop()
        state.model!.currentPage = page
        state.model!.wordIndex = 0
        state.model!.wordRange = []
        updateModel(state.model!)
    }
    
    @MainActor
    func play() {
        guard state.model != nil else { return }
        
        let spoken = state.text.index(state.text.startIndex, offsetBy: state.model!.wordRange.first ?? 0)
        let utterance = AVSpeechUtterance(string: String(state.text[spoken...]))
        utterance.voice = state.voices.first(where: { $0.identifier == UserDefaults.standard.value(forKey: Constants.voice) as? String}) ?? AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = UserDefaults.standard.value(forKey: Constants.speechRate) as? Float ?? 0.5
        
        NotificationService.shared.showMediaStyleNotification()
        
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
            let range = NSRange(location: startIndex, length: endIndex - startIndex)
            
            state.wordRange = range
            state.progress = progress
            state.model?.progress = Int(Double(progress) * 100.0)
            state.model?.wordIndex = wordIndex - 1
            state.model?.wordRange = [range.lowerBound, range.location]
        }
    }
}

extension SpeechService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        state.isPlaying = true
        NotificationService.shared.showMediaStyleNotification()
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        state.isPlaying = false
        NotificationService.shared.showMediaStyleNotification()
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        state.isPlaying = true
        NotificationService.shared.showMediaStyleNotification()
    }
    @MainActor func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        state.isPlaying = false
        NotificationService.shared.showMediaStyleNotification()
        if _wordIndex >= _words.count - 1 {
            nextPage()
        }
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString: NSRange, utterance: AVSpeechUtterance) {
        if (wordIndex < words.count) {
            updateProgress()
        }
    }
}
