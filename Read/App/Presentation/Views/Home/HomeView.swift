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
    @Environment(LibraryViewModel.self) private var libraryVM
    @Environment(SettingsViewModel.self) private var settingsVM
    @Environment(SpeechService.self) private var speechService
    @Environment(SnackBarService.self) private var snackbar
    
    @State private var pickDoc: Bool = false
    
    @State private var imageItem: PhotosPickerItem?
    
    @State private var showTextField: Bool = false
    @State private var link: String = ""
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                ListTileView(asset: Symbols.doc.resizable().frame(width: 40, height: 40),title: "Pick document", subtitle: "SizeTransform defines how the size")
                    .onTapGesture {
                        pickDoc.toggle()
                    }
                PhotosPicker(selection: $imageItem, matching: .images, photoLibrary: .shared()) {
                    ListTileView(asset: Symbols.photo.resizable().frame(width: 40, height: 40),title: "Pick image", subtitle: "SizeTransform defines how the size")
                }
                
                ListTileView(asset: Symbols.link.resizable().frame(width: 40, height: 40),title: "Paste web link", subtitle: "SizeTransform defines how the size")
                    .onTapGesture {
                        showTextField.toggle()
                    }
                
                Spacer(minLength: 100)
            }
            .padding()
            
        }
        .navigationTitle("Home")
        .sheet(isPresented: $showTextField) {
            EnterUrlSheet()
                .presentationDetents([.medium])
        }
        .sheet(isPresented: Binding(
            get: { settingsVM.showWhatsNew },
            set: { settingsVM.showWhatsNew = $0 }
        )) {
            WhatsNewView()
                .presentationDetents([.medium, .large])
        }
        .fileImporter(isPresented: $pickDoc, allowedContentTypes: [.pdf], onCompletion: { result in
            do{
                let url = try result.get()
                let docUrl = URL.documentsDirectory.appending(path: url.name)
                
                try FileManager.default.copyItem(at: url, to: docUrl)
                
                let file = FileModel(name: docUrl.name, type: .pdf, path: docUrl.lastPathComponent)
                // TODO: should be inserted on success of update model
                libraryVM.insertItem(file: file)
                speechService.updateModel(file)
            }
            catch{
                snackbar.displayMessage(error.localizedDescription)
                print("error reading file \(error.localizedDescription)")
            }
        }
        )
        .onChange(of: imageItem) {
            guard imageItem != nil else {
                return
            }
            Task {
                if let loaded = try? await imageItem?.loadTransferable(type: Data.self) {
                    let url = URL.documentsDirectory.appending(path: "image.jpg")
                    do {
                        try loaded.write(to: url, options: [.atomic, .completeFileProtection])
                        let file = FileModel(name: url.name, type: .image, path: url.lastPathComponent)
                        // TODO: should be inserted on success of update model
                        libraryVM.insertItem(file: file)
                        speechService.updateModel(file)
                    } catch {
                        snackbar.displayMessage(error.localizedDescription)
                        print(error.localizedDescription)
                    }
                } else {
                    snackbar.displayMessage("Failed to process image")
                    print("Failed")
                }
            }
        }
    }
}

