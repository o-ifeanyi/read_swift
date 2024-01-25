//
//  TextParser.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 25/01/2024.
//

import SwiftUI
import PDFKit
import PhotosUI
import Vision
import SwiftSoup

struct TextParser {
    static func parsePdf(pdf: PDFDocument, result: Binding<String?>) {
        guard let page = pdf.page(at: 0) else { return }
        guard let pageContent = page.attributedString else { return }
        
        result.wrappedValue = pageContent.string
    }
    
    @MainActor static func parseImage(image: Image, result: Binding<String?>) {
        let renderer = ImageRenderer(content: image)
        if let cgImage = renderer.uiImage?.cgImage {
            let handler = VNImageRequestHandler(cgImage: cgImage)
            
            let recognizeRequest = VNRecognizeTextRequest { (request, error) in
                guard let data = request.results as? [VNRecognizedTextObservation] else {
                    return
                }
                let stringArray = data.compactMap { result in
                    result.topCandidates(1).first?.string
                }
                DispatchQueue.main.async {
                    result.wrappedValue = stringArray.joined(separator: "\n")
                }
            }
            
            recognizeRequest.recognitionLevel = .accurate
            do {
                try handler.perform([recognizeRequest])
            } catch {
                print(error)
            }
        }
    }
    
    static func parseUrl(link: String, result: Binding<String?>) {
        guard let url = URL(string: link) else {
            result.wrappedValue = "Invalid url"
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                if let htmlString = String(data: data, encoding: .utf8) {
                    do {
                        let doc = try SwiftSoup.parse(htmlString)
                        let text = try doc.text()
                        DispatchQueue.main.async {
                            result.wrappedValue = text
                        }
                    } catch {
                        print("Parsing error")
                    }
                }
            } else if let error = error {
                print("Network error: \(error.localizedDescription)")
            }
        }.resume()
    }
}
