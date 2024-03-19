//
//  EnterTextView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 18/03/2024.
//

import SwiftUI

struct EnterTextView: View {
    @Environment(Router.self) private var router
    @Environment(LibraryViewModel.self) private var libraryVM
    @Environment(SpeechService.self) private var speechService
    
    private var textLimit = 4000
    @State private var text: String = ""
    @FocusState var isInputActive: Bool
    
    var body: some View {
        ScrollView {
            TextEditor(text: $text)
                .focused($isInputActive)
                .limitText($text, to: textLimit)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        
                        Button("Done") {
                            isInputActive = false
                        }
                    }
                }
                .frame(height: UIScreen.height * 0.5)
            
            HStack {
                Spacer()
                Text("\(text.count)/\(textLimit)")
                    .font(.subheadline)
            }
            
            Spacer(minLength: 10)
            
            AppButton(text: "Continue", action: {
                do {
                    let docName = "\(Date.now.ISO8601Format()).txt"
                    let docUrl = URL.documentsDirectory.appending(path: docName)
                    
                    // needed to prevent error reading file issue
                    let _ = docUrl.startAccessingSecurityScopedResource()
                    
                    try text.write(to: docUrl, atomically: true, encoding: String.Encoding.utf8)
                    
                    let file = FileModel(name: docUrl.name, type: .txt, path: docUrl.lastPathComponent)
                    // TODO: should be inserted on success of update model
                    libraryVM.insertItem(file: file)
                    speechService.updateModel(file)
                    router.pop()
                } catch {
                    print(error.localizedDescription)
                }
                
            })
            
            Spacer(minLength: 100)
        }
        .navigationTitle("Enter text")
        .padding()
    }
}
