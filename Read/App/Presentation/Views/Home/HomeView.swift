//
//  HomeView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 20/01/2024.
//

import SwiftUI
import PhotosUI

struct HomeView: View {
    @Environment(Router.self) private var router
    @Environment(LibraryViewModel.self) private var libraryVM
    @Environment(SettingsViewModel.self) private var settingsVM
    @Environment(SpeechService.self) private var speechService
    @Environment(AppStateService.self) private var appState
    
    @State private var pickDoc: Bool = false
    
    @State private var imageItem: PhotosPickerItem?
    
    @State private var showTextField: Bool = false
    @State private var link: String = ""
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                ListTileView(asset: Symbols.doc.resizable().frame(width: 40, height: 40),title: "Pick document", subtitle: "Listen to the content of a PDF")
                    .onTapGesture { pickDoc = true }
                
                PhotosPicker(selection: $imageItem, matching: .images, photoLibrary: .shared()) {
                    ListTileView(asset: Symbols.photo.resizable().frame(width: 40, height: 40),title: "Pick image", subtitle: "Listen to the content of an image")
                }
                
                ListTileView(asset: Symbols.text.resizable().frame(width: 40, height: 40),title: "Paste or write text", subtitle: "Listen to the content of the text")
                    .onTapGesture { router.push(.enterText) }
                
                ListTileView(asset: Symbols.link.resizable().frame(width: 40, height: 40),title: "Paste web link", subtitle: "Listen to the content of a website")
                    .onTapGesture { showTextField = true }
                
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
                AnalyticService.shared.track(event: "select_doc")
                let docUrl = URL.documentsDirectory.appending(path: url.name)
                
                // needed to prevent error reading file issue
                let _ = url.startAccessingSecurityScopedResource()
                
                try FileManager.default.copyItem(at: url, to: docUrl)
                
                let file = FileModel(name: docUrl.name, type: .pdf, path: docUrl.lastPathComponent)
                speechService.updateModel(file) {
                    // insert on success of update model
                    libraryVM.insertItem(file: file)
                }
            }
            catch{
                appState.displayMessage(error.localizedDescription)
            }
        })
        .onChange(of: imageItem) {
            guard imageItem != nil else {
                return
            }
            Task {
                AnalyticService.shared.track(event: "select_image")
                if let loaded = try? await imageItem?.loadTransferable(type: Data.self) {
                    let docName = "\(Date.now.ISO8601Format()).jpg"
                    let url = URL.documentsDirectory.appending(path: docName)
                    do {
                        try loaded.write(to: url, options: [.atomic, .completeFileProtection])
                        let file = FileModel(name: url.name, type: .img, path: url.lastPathComponent)
                        speechService.updateModel(file) {
                            // insert on success of update model
                            libraryVM.insertItem(file: file)
                        }
                    } catch {
                        appState.displayMessage(error.localizedDescription)
                        print(error.localizedDescription)
                    }
                } else {
                    appState.displayMessage("Failed to process image")
                }
            }
        }
        .task {
            speechService.initSpeechService()
        }
    }
}

