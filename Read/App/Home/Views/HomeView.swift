//
//  HomeView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 20/01/2024.
//

import SwiftUI
import PDFKit
import PhotosUI


struct PDFKitView: UIViewRepresentable {
    
    let pdfDocument: PDFDocument
    
    init(showing pdfDoc: PDFDocument) {
        self.pdfDocument = pdfDoc
    }
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = pdfDocument
    }
}

struct HomeView: View {
    @Environment(SpeechService.self) private var speechService
    @State private var speechText: String?
    
    @State private var pickDoc: Bool = false
    @State private var doc: PDFDocument?
    
    
    @State private var imageItem: PhotosPickerItem?
    @State private var image: Image?
    
    @State private var showTextField: Bool = false
    @State private var link: String = ""
    
    func reset(_ all: Bool = true) {
        pickDoc = false
        doc = nil
        showTextField = false
        speechText = nil
        if all {
            imageItem = nil
            image = nil
        }
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    Button("Pick document") {
                        reset()
                        pickDoc.toggle()
                    }
                    .buttonStyle(.bordered)
                    
                    PhotosPicker("Pick image", selection: $imageItem, matching: .images)
                        .buttonStyle(.bordered)
                    
                    Button("Enter url") {
                        reset()
                        showTextField.toggle()
                    }
                    .buttonStyle(.bordered)
                }
                
                if doc != nil {
                    PDFKitView(showing: doc!)
                        .frame(width: 300, height: 400)
                    
                    Button("Extract pdf text") {
                        TextParser.parsePdf(pdf: doc!, result: $speechText)
                    }
                    .buttonStyle(.bordered)
                }
                
                if image != nil {
                    image!
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                    
                    Button("Extract image text") {
                        TextParser.parseImage(image: image!, result: $speechText)
                    }
                    .buttonStyle(.bordered)
                }
                
                if showTextField {
                    TextField("Enter url", text: $link)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Extract url text") {
                        TextParser.parseUrl(link: link, result: $speechText)
                    }
                    .buttonStyle(.bordered)
                }
                
                if speechText != nil {
                    Text(speechText!)
                        .onAppear {
                            speechService.updateText(speechText!)
                        }
                }
            }
            .padding()
            
        }
        .fileImporter(isPresented: $pickDoc, allowedContentTypes: [.pdf], onCompletion: { result in
            do{
                let fileURL = try result.get()
                if let pdf = PDFDocument(url: fileURL) {
                    doc = pdf
                }
            }
            catch{
                print("error reading file \(error.localizedDescription)")
            }
        }
        )
        .onChange(of: imageItem) {
            guard imageItem == nil else {
                reset(false)
                Task {
                    if let loaded = try? await imageItem?.loadTransferable(type: Image.self) {
                        image = loaded
                    } else {
                        print("Failed")
                    }
                }
                return
            }
            
        }
    }
}


#Preview {
    HomeView()
        .environment(SpeechService.shared)
}
