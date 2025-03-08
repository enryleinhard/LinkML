//
//  PipelineManager.swift
//  LinkML
//
//  Created by Enryl Einhard on 4/2/2025.
//

import Foundation
import CoreML
import Collections

class PipelineManager: ObservableObject {
    private var linkModelManager: LinkModelManager
    private var linkPeripheralManager: LinkPeripheralManager
    
    @Published var availablePipelines: OrderedDictionary<UUID, Pipeline>
    
    init(linkModelManager: LinkModelManager, linkPeripheralManager: LinkPeripheralManager) {
        self.linkModelManager = linkModelManager
        self.linkPeripheralManager = linkPeripheralManager
        self.availablePipelines = [:]
    }
    
    func getPipeline(for pipelineId: UUID) -> Pipeline? {
        return availablePipelines[pipelineId]
    }
    
    func addPipeline(pipeline: Pipeline) {
        availablePipelines[pipeline.id] = pipeline
    }
    
    func removePipeline(for pipelineId: UUID) {
        availablePipelines.removeValue(forKey: pipelineId)
    }
    
    func findPipelineIdsByCharacteristicIdentifier(characteristicIdentifier: CharacteristicIdentifier) -> [UUID] {
        var pipelineIds = [UUID]()
        
        self.availablePipelines.elements.forEach { pipelineId, pipeline in
            if pipeline.inputToCharacteristicMapping.values.contains(characteristicIdentifier) {
                pipelineIds.append(pipelineId)
            }
        }
        
        return pipelineIds
    }
    
    func executePipeline(characteristicIdentifier: CharacteristicIdentifier) {
        let pipelineIds = findPipelineIdsByCharacteristicIdentifier(characteristicIdentifier: characteristicIdentifier)
        
        for pipelineId in pipelineIds {
            
            guard let foundPipeline = getPipeline(for: pipelineId),
                  let foundCoreMLModel = linkModelManager.getModel(from: foundPipeline.linkModelId)?.coreMLModel else {
                continue
            }
            
            var modelInput: [String: Any] = [:]
            
            for (modelInputKey, charIdentifier) in foundPipeline.inputToCharacteristicMapping {
                guard let characteristic = linkPeripheralManager.getCharacteristicByIdentifier(identifier: charIdentifier) else {
                    continue
                }
                
                switch characteristic.type {
                case .data:
                    modelInput[modelInputKey] = characteristic.getValueAsData()
                case .string:
                    modelInput[modelInputKey] = characteristic.getValueAsString()
                case .int:
                    modelInput[modelInputKey] = characteristic.getValueAsInt()
                case .double:
                    modelInput[modelInputKey] = characteristic.getValueAsInt()
                }
                
            }
            
            do {
                let modelInputProvider = try MLDictionaryFeatureProvider(dictionary: modelInput)
                let modelOutput = try foundCoreMLModel.prediction(from: modelInputProvider)
                
                var outputResult = [String: Any]()
                for featureName in modelOutput.featureNames {
                    let featureValue = modelOutput.featureValue(for: featureName)
                    
                    if featureValue?.type == .int64 {
                        outputResult[featureName] = featureValue?.int64Value
                    } else if featureValue?.type == .double {
                        outputResult[featureName] = featureValue?.doubleValue
                    } else if featureValue?.type == .string {
                        outputResult[featureName] = featureValue?.stringValue
                    }
                }
                
                availablePipelines[pipelineId]?.updatePipelineOutput(to: outputResult)
                
            } catch {
                print("Error creating model input provider, error: \(error)")
            }
            
        }
        
    }
}
