//
//  ModelsView.swift
//  LinkML
//
//  Created by Enryl Einhard on 31/1/2025.
//

import SwiftUI

struct ModelsView: View {
    @EnvironmentObject var linkModelManager: LinkModelManager
    @EnvironmentObject var downloadManager: DownloadManager
    @State var isAddingNewModel = false
    
    var body: some View {
        NavigationView {
            VStack () {
                List(linkModelManager.availableModels.elements, id: \.key) { linkModelId, linkModel in
                    ModelView(linkModel: linkModel)
                        .environmentObject(linkModelManager)
                }
                .listStyle(.grouped)
            }
            .navigationTitle("Models")
            .toolbar {
                Button {
                    self.isAddingNewModel.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
            .refreshable {
                print("Refreshing models...")
            }
            .sheet(isPresented: $isAddingNewModel) {
                NewModelView(
                    isPresented: $isAddingNewModel
                )
                .environmentObject(linkModelManager)
                .environmentObject(downloadManager)
            }
            .textFieldStyle(.roundedBorder)
            
        }
    }
}
