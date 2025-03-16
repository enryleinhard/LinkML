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
    
    var pathURL: URL?
    var coreMLModel: MLModel?
    
    var downloadProgress: Double?
    
    var isDownloading: Bool {
        downloadProgress != nil
    }
    var isReady: Bool {
        downloadProgress == nil && pathURL != nil
    }
    var isLoaded: Bool {
        coreMLModel != nil
    }
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.pathURL = nil
        self.coreMLModel = nil
        self.downloadProgress = nil
    }
    
    init(name: String, pathURL: URL) {
        self.id = UUID()
        self.name = name
        self.pathURL = pathURL
        self.coreMLModel = nil
        self.downloadProgress = nil
    }
    
    mutating func loadModel() {
        if (self.isReady) {
            do {
                let coreMLModel = try MLModel(contentsOf: pathURL!)
                self.coreMLModel = coreMLModel
            } catch {
                print("ERR: Model loading failed.")
            }
        } else {
            print("ERR: Model is not ready.")
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
