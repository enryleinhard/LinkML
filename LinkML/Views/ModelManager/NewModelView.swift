//
//  NewModelView.swift
//  LinkML
//
//  Created by Enryl Einhard on 31/1/2025.
//

import SwiftUI

struct NewModelView: View {
    @EnvironmentObject var linkModelManager: LinkModelManager
    @Binding var isPresented: Bool
    
    @State var modelName = ""
    @State var modelDownloadURL: String = ""
    
    @State var isDownloading = false
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        TextField("Name", text: $modelName)
                    } header: {
                        Text("General")
                    } footer: {
                        Text("Please enter the name of the model.")
                    }
                    
                    Section {
                        TextField("Name", text: $modelDownloadURL)
                    } header: {
                        Text("URL")
                    } footer: {
                        Text("Please enter the URL where the model is located.")
                    }
                }
            }
            .navigationTitle("New Model")
            .toolbar {
                ToolbarItem (placement: .topBarLeading) {
                    Button {
                        self.isPresented.toggle()
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem (placement: .topBarTrailing) {
                    Button {
                        self.isPresented.toggle()
                    } label: {
                        Text("Confirm")
                    }
                    .disabled(isDownloading)
                }
            }
        }
    }
    
    func downloadModel() {
        Task {
//            isDownloading.toggle()
//            await linkModelManager.downloadAndSaveModel(from: downloadURL)
//            availableModelURLs = linkModelManager.fetchAvailableModels()
//            downloadURL.removeAll()
//            isDownloading.toggle()
//            isPresented.toggle()
        }
    }
}
