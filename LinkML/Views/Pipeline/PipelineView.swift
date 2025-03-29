//
//  PipelineView.swift
//  LinkML
//
//  Created by Enryl Einhard on 16/3/2025.
//

import SwiftUI

struct PipelineView: View {
    let pipeline: Pipeline
    
    var body: some View {
        NavigationLink(
            destination: PipelineDetailView(pipeline: pipeline)
        ) {
            HStack {
                Image(systemName: "list.bullet")
                VStack(
                    alignment: .leading
                ) {
                    Text(pipeline.pipelineName)
                    Text(pipeline.id.uuidString)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding(4)
        }
    }
}
