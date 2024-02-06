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
    @Environment(LibraryViewModel.self) private var libraryViewModel
    @Environment(SpeechService.self) private var speechService
    
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
            EnterUrlView()
                .presentationDetents([.medium])
        }
        .fileImporter(isPresented: $pickDoc, allowedContentTypes: [.pdf], onCompletion: { result in
            do{
                let url = try result.get()
                let file = FileModel(name: url.name, type: .pdf, path: url.absoluteString)
                // TODO: should be inserted on success of update model
                libraryViewModel.insertItem(file: file)
                speechService.updateModel(file)
            }
            catch{
                print("error reading file \(error.localizedDescription)")
            }
        }
        )
        .onChange(of: imageItem) {
            guard imageItem == nil else {
                PermissionService.shared.requestPhotoAccess {
                    if let localID = imageItem!.itemIdentifier {
                        let result = PHAsset.fetchAssets(withLocalIdentifiers: [localID], options: nil)
                        if let asset = result.firstObject {
                            asset.requestContentEditingInput(with: PHContentEditingInputRequestOptions()) { (eidtingInput, info) in
                                if let input = eidtingInput, let url = input.fullSizeImageURL {
                                    let file = FileModel(name: url.name, type: .image, path: url.absoluteString)
                                    // TODO: should be inserted on success of update model
                                    libraryViewModel.insertItem(file: file)
                                    speechService.updateModel(file)
                                }
                            }
                        }
                    }
                }
                return
            }
            
        }
    }
}

