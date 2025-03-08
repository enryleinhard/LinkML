//
//  ModelManagerView.swift
//  LinkML
//
//  Created by Enryl Einhard on 31/1/2025.
//

import SwiftUI

struct ModelsView: View {
    @EnvironmentObject var linkModelManager: LinkModelManager
    @State var isAddingNewModel = false
    
    var body: some View {
        NavigationView {
            VStack () {
                List(linkModelManager.availableModels.elements, id: \.key) { linkModelId, linkModel in
                    HStack {
                        Image(systemName: "function")
                        VStack(alignment: .leading) {
                            Text("\(linkModel.name)")
                                .bold()
                            Text("\(linkModelId)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button(action: {
                            if (linkModel.isModelLoaded) {
                                linkModelManager.deloadModel(on: linkModelId)
                            } else {
                                linkModelManager.loadModel(on: linkModelId)
                            }
                        }) {
                            if (linkModel.isModelLoaded) {
                                Text("Deload").font(.body).foregroundStyle(.red)
                            } else {
                                Text("Load").font(.body)
                            }
                        }
                    }
                    .padding(2)
                }
                .listStyle(.grouped)
            }
            .navigationTitle("Available Models")
            .toolbar {
                Button {
                    self.isAddingNewModel.toggle()
                } label: {
                    Image(systemName: "plus")
                    Text("New")
                }
            }
            .sheet(isPresented: $isAddingNewModel) {
                NewModelView(
                    isPresented: $isAddingNewModel
                )
            }
            .textFieldStyle(.roundedBorder)
            .environmentObject(linkModelManager)
        }
    }
}
