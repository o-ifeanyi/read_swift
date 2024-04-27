//
//  TextParser.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 25/01/2024.
//

import PDFKit
import Vision
import SwiftSoup
import GoogleGenerativeAI

struct TextParser {
    static func parsePdf(url: URL, page: Int, perform action: @escaping (_ result: String, _ pageCount: Int, _ error: ReadError?) -> Void) {
        if let pdf = PDFDocument(url: url) {
            guard let page = pdf.page(at: page - 1) else { return }
            guard let pageContent = page.attributedString else { return }
            
            action(pageContent.string.formatted, pdf.pageCount, nil)
        } else {
            action("An error occurred while reading pdf", 0, .error)
        }
    }
    
    @MainActor static func parseImage(url: URL, perform action: @escaping (_ result: String, _ genereated: Bool?, _ error: ReadError?) -> Void) {
        do {
            let imageData = try Data.init(contentsOf: url)
            let image = UIImage(data: imageData)
            
            guard let cgImage = image?.cgImage else {
                action("An error occurred while reading image", nil, .invalidData)
                return
            }
            let handler = VNImageRequestHandler(cgImage: cgImage)
            
            var result: String = ""
            
            let recognizeRequest = VNRecognizeTextRequest { (request, error) in
                guard let data = request.results as? [VNRecognizedTextObservation] else {
                    action("An error occurred while reading image", nil, .invalidData)
                    return
                }
                let stringArray = data.compactMap { result in
                    result.topCandidates(1).first?.string
                }
                
                result = stringArray.joined(separator: " ")
                
            }
            
            recognizeRequest.recognitionLevel = .accurate
            try handler.perform([recognizeRequest])
            if result.isEmpty {
                Task {
                    AnalyticService.shared.track(event: "describe_image")
                    let model = GenerativeModel(name: "gemini-pro-vision", apiKey: APIKey.gemini)
                    
                    let response = try? await model.generateContent(Constants.describeImagePromt, image!)
                    if let text = response?.text {
                        AnalyticService.shared.track(event: "describe_image_success")
                        action(text, true, nil)
                    } else {
                        action("Something went wrong. Could not generate a description for this image", false, nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    action(result.formatted, false, nil)
                }
            }
        } catch {
            action("An error occurred while reading image: \(error.localizedDescription)", nil, .error)
        }
    }
    
    static func parseText(url: URL, perform action: @escaping (_ result: String, _ error: ReadError?) -> Void) {
        do {
            let content = try String(contentsOf: url)
            action(content.formatted, nil)
        } catch {
            action("An error occurred while reading text: \(error.localizedDescription)", .error)
        }
    }
    
    static func parseUrl(link: String, perform action: @escaping (_ result: String, _ error: ReadError?) -> Void) {
        guard let url = URL(string: link) else {
            action("Please enter a valid url", .invalidUrl)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                if let htmlString = String(data: data, encoding: .utf8) {
                    do {
                        let doc = try SwiftSoup.parse(htmlString)
                        let text = try doc.text()
                        DispatchQueue.main.async {
                            action(text.formatted, nil)
                        }
                    } catch {
                        action("An error occured while parsing url content: \(error.localizedDescription)", .error)
                    }
                }
            } else if let error = error {
                action("A network error occurred: \(error.localizedDescription)", .error)
            }
        }.resume()
    }
}
