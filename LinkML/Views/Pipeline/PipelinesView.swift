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
                    PipelineView(pipeline: pipeline)
                }
                .listStyle(.grouped)
            }
            .navigationTitle("Pipelines")
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
