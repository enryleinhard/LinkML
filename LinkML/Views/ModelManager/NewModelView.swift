//
//  NewModelView.swift
//  LinkML
//
//  Created by Enryl Einhard on 31/1/2025.
//

import SwiftUI

struct NewModelView: View {
    @EnvironmentObject var linkModelManager: LinkModelManager
    @EnvironmentObject var downloadManager: DownloadManager
    @Binding var isPresented: Bool
    
    @State var modelName = ""
    @State var modelURLString: String = ""
    
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
                        TextField("Name", text: $modelURLString)
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
                        self.downloadModel(from: modelURLString)
                    } label: {
                        Text("Confirm")
                    }
                }
            }
        }
    }
    
    func downloadModel(from: String) {
        let downloadURL = URL(string: from)
        guard let downloadURL = downloadURL else {
            return
        }
        linkModelManager.downloadModel(modelName: modelName, modelURL: downloadURL)
        isPresented.toggle()
    }
}
