//
//  PipelinesView.swift
//  LinkML
//
//  Created by Enryl Einhard on 31/1/2025.
//

import SwiftUI

struct PipelinesView: View {
    @EnvironmentObject var linkModelManager: LinkModelManager
    @EnvironmentObject var linkPeripheralManager: LinkPeripheralManager
    @EnvironmentObject var pipelineManager: PipelineManager
    
    @State var isAddingNewPipeline = false
    
    var body: some View {
        NavigationView {
            VStack () {
                List(pipelineManager.availablePipelines.elements, id: \.key) { pipelineId, pipeline in
                    NavigationLink (
                        destination: PipelineDetailView(pipeline: pipeline)
                    )
                    {
                        HStack {
                            Image(systemName: "list.bullet")
                            VStack(
                                alignment: .leading
                            ) {
                                Text(pipeline.pipelineName)
                                    .bold()
                                
                                Text(pipelineId.uuidString)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Button(action: {
                                
                            }) {
                                Image(systemName: "square.and.pencil")
                            }
                        }
                        .padding(2)
                    }
                }
                .listStyle(.grouped)
            }
            .navigationTitle("Data Pipelines")
            .toolbar {
                Button {
                    self.isAddingNewPipeline.toggle()
                } label: {
                    Image(systemName: "plus")
                    Text("New")
                }
            }
            .sheet(isPresented: $isAddingNewPipeline) {
                NewPipelineView(
                    isPresented: $isAddingNewPipeline
                )
                    
            }
        }
        .environmentObject(linkModelManager)
        .environmentObject(linkPeripheralManager)
        .environmentObject(pipelineManager)
    }
}


#Preview {
    PipelinesView()
}
