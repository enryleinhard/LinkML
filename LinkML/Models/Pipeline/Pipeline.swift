//
//  Pipeline.swift
//  LinkML
//
//  Created by Enryl Einhard on 4/2/2025.
//

import Foundation

import CoreBluetooth
import CoreML

struct Pipeline: Identifiable {
    let id: UUID
    let linkModelId: UUID
    
    let pipelineName: String
    var description: String { "Pipeline: \(pipelineName)" }
    
    let inputToCharacteristicMapping: [String: CharacteristicIdentifier]
    var pipelineOutput: [String: Any]
    
    init(pipelineName: String, linkModelId: UUID, inputMapping: [String: CharacteristicIdentifier]) {
        self.id = UUID()
        self.pipelineName = pipelineName
        self.linkModelId = linkModelId
        self.inputToCharacteristicMapping = inputMapping
        self.pipelineOutput = [:]
    }
    
    mutating func updatePipelineOutput(to newOutput: [String: Any]) {
        self.pipelineOutput = newOutput
    }
}
