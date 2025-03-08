//
//  PipelineDetailView.swift
//  LinkML
//
//  Created by Enryl Einhard on 5/2/2025.
//

import SwiftUI

struct PipelineDetailView: View {
    @EnvironmentObject var linkPeripheralManager: LinkPeripheralManager
    
    let pipeline: Pipeline
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Group {
                    Text("UUID: \(pipeline.id)")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                
                Divider()
                Group {
                    Text("Pipeline Input").bold()
                    ForEach(pipeline.inputToCharacteristicMapping.sorted(by: { $0.key < $1.key }), id: \.key) { inputKey, inputCharIdentifier in
                        if let characteristic = linkPeripheralManager.getCharacteristicByIdentifier(identifier: inputCharIdentifier) {
                            HStack {
                                CharacteristicValueView(characteristic: characteristic, trailingText: inputKey)
                                Spacer()
                            }
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                }
                
                Divider()
                Group {
                    Text("Pipeline Output").bold()
                    ForEach(pipeline.pipelineOutput.sorted(by: { $0.key < $1.key }), id: \.key) { outputKey, outputResult in
                        HStack {
                            Text("\(outputKey):  \(outputResult)")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .navigationTitle("Pipeline A")
        }
    }
}
