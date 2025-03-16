//
//  NewPipelineView.swift
//  LinkML
//
//  Created by Enryl Einhard on 4/2/2025.
//
import SwiftUI

struct NewPipelineView: View {
    @EnvironmentObject var linkModelManager: LinkModelManager
    @EnvironmentObject var linkPeripheralManager: LinkPeripheralManager
    @EnvironmentObject var pipelineManager: PipelineManager
    
    @Binding var isPresented: Bool
    
    @State private var pipelineName: String = ""
    @State private var selectedLinkModelId: UUID?
    @State private var modelInputMapping: [String: CharacteristicIdentifier] = [:]
    
    var body: some View {
        NavigationView {
            VStack() {
                Form {
                    Section {
                        TextField("Name", text: $pipelineName)
                    } header: {
                        Text("General")
                    } footer: {
                        Text("Please enter the name of the pipeline.")
                    }
                    
                    Section {
                        Picker("Model", selection: $selectedLinkModelId) {
                            ForEach(linkModelManager.availableModels.elements, id: \.key) { linkModelId, linkModel in
                                if linkModel.isLoaded {
                                    Text(linkModel.name).tag(linkModelId)
                                }
                            }
                        }
                        .pickerStyle(.navigationLink)
                    } header: {
                        Text("Details")
                    } footer: {
                        Text("Please select the CoreML model that will be used.")
                    }
                    
                    if  let selectedLinkModelId = selectedLinkModelId,
                        let selectedLinkModel = linkModelManager.getModel(from: selectedLinkModelId) {
                        Section {
                            ForEach(selectedLinkModel.getInputTypes().sorted(by: { $0.key < $1.key }), id: \.key) { inputName, inputType in
                                Picker("\(inputName) (\(inputType))", selection: $modelInputMapping[inputName]) {
                                    ForEach(linkPeripheralManager.getAllCharacteristic(), id: \.self) { charIdentifier in
                                        CharacteristicPickerItemView(characteristicIdentifier: charIdentifier)
                                    }
                                }
                                .pickerStyle(.navigationLink)
                            }
                        } header: {
                            Text("Inputs")
                        } footer: {
                            Text("Please select the input according to the BLE advertisement data.")
                        }
                    }
                }
            }
            .navigationTitle("New Pipeline")
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
                        if (pipelineName.isEmpty || modelInputMapping.isEmpty) {
                            return
                        }
                        
                        guard let selectedLinkModelId = selectedLinkModelId else {
                            return
                        }
                        
                        let newPipeline = Pipeline(
                            pipelineName: pipelineName,
                            linkModelId: selectedLinkModelId,
                            inputMapping: modelInputMapping
                        )
                        pipelineManager.addPipeline(pipeline: newPipeline)
                        self.isPresented.toggle()
                    } label: {
                        Text("Confirm")
                    }
                }
            }
        }
    }
}

struct CharacteristicPickerItemView: View {
    let characteristicIdentifier: CharacteristicIdentifier
    var body: some View {
        VStack (alignment: .leading) {
            Text("peripheralId").bold()
            Text(characteristicIdentifier.peripheralId.uuidString)
            Text("serviceId").bold()
            Text(characteristicIdentifier.serviceId.uuidString)
            Text("characteristicId").bold()
            Text(characteristicIdentifier.characteristicId.uuidString)
        }
        .font(.caption2)
        .tag(characteristicIdentifier)
    }
}
