//
//  NotificationService.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 25/02/2024.
//

import Foundation
import UserNotifications
import MediaPlayer

final class NotificationService {
    static let shared = NotificationService()
    
    func showMediaStyleNotification() {
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
            print("rewind")
            return .success
        }
        command.playCommand.isEnabled = true;
        command.playCommand.addTarget { event in
            print("play")
            return .success
        }
        command.pauseCommand.isEnabled = true;
        command.pauseCommand.addTarget { event in
            print("pause")
            return .success
        }
        command.skipForwardCommand.isEnabled = true;
        command.skipForwardCommand.addTarget { event in
            print("forward")
            return .success
        }
        
        var nowPlayingInfo = [String : Any]()
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = "File Title"
        nowPlayingInfo[MPMediaItemPropertyArtist] = "File Subtitle"
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = 60
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = 120
        
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
