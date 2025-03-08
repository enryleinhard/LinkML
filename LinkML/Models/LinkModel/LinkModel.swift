//
//  LinkMLModel.swift
//  LinkML
//
//  Created by Enryl Einhard on 30/1/2025.
//

import Foundation
import CoreML

struct LinkModel: Identifiable {
    let id: UUID
    let name: String
    
    let pathURL: URL
    
    var coreMLModel: MLModel?
    var isModelLoaded: Bool { coreMLModel != nil }
    
    init(name: String, pathURL: URL) {
        self.id = UUID()
        self.name = name
        self.pathURL = pathURL
    }
    
    mutating func loadModel() {
        do {
            let coreMLModel = try MLModel(contentsOf: pathURL)
            self.coreMLModel = coreMLModel
        } catch {
            print("Error loading model: \(error)")
        }
    }
    
    mutating func unloadModel() {
        self.coreMLModel = nil
    }
    
    func getInputTypes() -> [String : String] {
        guard let coreMLModel = self.coreMLModel else {
            return [:]
        }
        
        var inputTypes = [String : String]()
        let inputDescriptors = coreMLModel.modelDescription.inputDescriptionsByName
        
        inputDescriptors.forEach { k, v in
            
            let typeDescription: String
            
            switch v.type {
            case MLFeatureType.int64:
                typeDescription = "Int64"
            case MLFeatureType.double:
                typeDescription = "Double"
            case MLFeatureType.string:
                typeDescription = "String"
            default:
                typeDescription = "Unknown"
            }
            
            inputTypes[k] = typeDescription
        }
        
        return inputTypes
    }
}
