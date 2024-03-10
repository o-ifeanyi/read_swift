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
    static func parsePdf(url: URL, page: Int, perform action: @escaping (_ result: String, _ pageCount: Int) -> Void) {
        if let pdf = PDFDocument(url: url) {
            guard let page = pdf.page(at: page - 1) else { return }
            guard let pageContent = page.attributedString else { return }
            
            action(pageContent.string.replacing("\n", with: " "), pdf.pageCount)
        }
    }
    
    @MainActor static func parseImage(url: URL, perform action: @escaping (_ result: String) -> Void) {
        do {
            let imageData = try Data.init(contentsOf: url)
            let image = UIImage(data: imageData)
            
            guard let cgImage = image?.cgImage else {
                return
            }
            let handler = VNImageRequestHandler(cgImage: cgImage)
            
            let recognizeRequest = VNRecognizeTextRequest { (request, error) in
                guard let data = request.results as? [VNRecognizedTextObservation] else {
                    return
                }
                let stringArray = data.compactMap { result in
                    result.topCandidates(1).first?.string
                }
                DispatchQueue.main.async {
                    action(stringArray.joined(separator: " "))
                }
            }
            
            recognizeRequest.recognitionLevel = .accurate
            try handler.perform([recognizeRequest])
        } catch {
            print(error)
        }
    }
    
    static func parseUrl(link: String, perform action: @escaping (_ result: String) -> Void) {
        guard let url = URL(string: link) else {
            action("Invalid url")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                if let htmlString = String(data: data, encoding: .utf8) {
                    do {
                        let doc = try SwiftSoup.parse(htmlString)
                        let text = try doc.text()
                        DispatchQueue.main.async {
                            action(text)
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
