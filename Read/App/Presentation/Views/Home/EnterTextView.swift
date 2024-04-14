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
    @FocusState var fieldIsFocused: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            TextEditor(text: $text)
                .focused($fieldIsFocused)
                .limitText($text, to: textLimit)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        
                        Button("Done") {
                            fieldIsFocused = false
                        }
                    }
                }
                .padding(10)
                .scrollContentBackground(.hidden)
                .frame(height: UIScreen.height * 0.5)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            HStack {
                Spacer()
                Text("\(text.count)/\(textLimit)")
                    .font(.subheadline)
            }
            
            Spacer(minLength: 15)
            
            AppButton(text: "Continue", action: {
                do {
                    AnalyticService.shared.track(event: "enter_text")
                    let docName = "\(Date.now.ISO8601Format()).txt"
                    let docUrl = URL.documentsDirectory.appending(path: docName)
                    
                    // needed to prevent error reading file issue
                    let _ = docUrl.startAccessingSecurityScopedResource()
                    
                    try text.write(to: docUrl, atomically: true, encoding: String.Encoding.utf8)
                    
                    let file = FileModel(name: docUrl.name, type: .txt, path: docUrl.lastPathComponent)
                    speechService.updateModel(file) {
                        // sinsert on success of update model
                        libraryVM.insertItem(file: file)
                    }
                    router.pop()
                } catch {
                    print(error.localizedDescription)
                }
                
            })
            .disabled(text.isEmpty)
            
            Spacer(minLength: UIScreen.height * 0.5)
        }
        .padding()
        .navigationTitle("Enter text")
        .ignoresSafeArea(.keyboard)
        .task {
            fieldIsFocused = true
        }
    }
}
