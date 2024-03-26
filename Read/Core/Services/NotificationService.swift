//
//  NotificationService.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 25/02/2024.
//

import MediaPlayer

final class NotificationService {
    static let shared = NotificationService()
    var setup: Bool = false
    
    func showMediaStyleNotification() {
        defer { setup = true }
        
        if !setup {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Error setting the AVAudioSession:", error.localizedDescription)
            }
            
            let mediaController = MPMusicPlayerController.applicationMusicPlayer
            mediaController.beginGeneratingPlaybackNotifications()
            
            let command = MPRemoteCommandCenter.shared()
            command.skipBackwardCommand.isEnabled = true;
            command.skipBackwardCommand.addTarget { event in
                Task { await SpeechService.shared.rewind() }
                return .success
            }
            command.playCommand.isEnabled = true;
            command.playCommand.addTarget { event in
                Task { await SpeechService.shared.play() }
                return .success
            }
            command.pauseCommand.isEnabled = true;
            command.pauseCommand.addTarget { event in
                Task { await SpeechService.shared.pause() }
                return .success
            }
            command.skipForwardCommand.isEnabled = true;
            command.skipForwardCommand.addTarget { event in
                Task { await SpeechService.shared.forward() }
                return .success
            }
        }
        
        let state = SpeechService.shared.state
        let file = state.model
        
        guard file != nil else { return }
        
        var nowPlayingInfo = [String : Any]()
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = "\(file!.name)"
        nowPlayingInfo[MPMediaItemPropertyArtist] = "\(file!.type)"
        
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
