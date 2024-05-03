//
//  ScanView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 30/04/2024.
//

import SwiftUI
import VisionKit

struct ScanSheet: UIViewControllerRepresentable {
    
    @Environment(\.dismiss) var dismiss
    var action: (_ images: [CGImage]) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentViewController = VNDocumentCameraViewController()
        documentViewController.delegate = context.coordinator
        return documentViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: ScanSheet
        
        init(parent: ScanSheet) {
            self.parent = parent
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let images = extractImages(from: scan)
            parent.dismiss()
            parent.action(images)
        }
        
        private func extractImages(from scan: VNDocumentCameraScan) -> [CGImage] {
            var images = [CGImage]()
            for index in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: index)
                guard let cgImage = image.cgImage else { continue }
                
                images.append(cgImage)
            }
            return images
        }
    }
}
