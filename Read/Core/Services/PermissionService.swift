//
//  PermissionService.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 04/02/2024.
//

import SwiftUI
import Photos

final class PermissionService {
    static let shared = PermissionService()
    
    func requestPhotoAccess(onGranted: @escaping () -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()

        switch status {
        case .notDetermined:
          PHPhotoLibrary.requestAuthorization { newStatus in
            if newStatus == .authorized {
              print("Access granted.")
                onGranted()
            } else {
              print("Access denied.")
            }
          }
        case .authorized:
          print("Access already granted.")
            onGranted()
        case .restricted, .denied:
          print("Access denied or restricted.")
        case .limited:
          print("Access limited.")
            onGranted()
        default:
          print("Unknown authorization status.")
        }
      }
}
