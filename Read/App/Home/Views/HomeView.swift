//
//  HomeView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 20/01/2024.
//

import SwiftUI
import PDFKit
import PhotosUI

struct HomeView: View {
    @Environment(SpeechService.self) private var speechService
    @State private var speechText: String?
    
    @State private var pickDoc: Bool = false
    
    @State private var imageItem: PhotosPickerItem?
    
    @State private var showTextField: Bool = false
    @State private var link: String = ""
    
    func reset(_ all: Bool = true) {
        pickDoc = false
        showTextField = false
        speechText = nil
        if all {
            imageItem = nil
        }
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                ListTileView(title: "Pick document", subtitle: "SizeTransform defines how the size should animate between the.")
                    .onTapGesture {
                        reset()
                        pickDoc.toggle()
                    }
                PhotosPicker(selection: $imageItem, matching: .images) {
                    ListTileView(title: "Pick image", subtitle: "SizeTransform defines how the size should animate between the.")
                }
                
                ListTileView(title: "Paste web link", subtitle: "SizeTransform defines how the size should animate between the.")
                    .onTapGesture {
                        reset()
                        showTextField.toggle()
                    }
                
                
                if showTextField {
                    TextField("Enter url", text: $link)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            TextParser.parseUrl(link: link, perform: { result in
                                link = ""
                                showTextField.toggle()
                                speechService.updateText(result)
                            })
                        }
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
                    TextParser.parsePdf(pdf: pdf, perform: { result in
                        speechService.updateText(result)
                    })
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
                        TextParser.parseImage(image: loaded, perform: { result in
                            speechService.updateText(result)
                        })
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
