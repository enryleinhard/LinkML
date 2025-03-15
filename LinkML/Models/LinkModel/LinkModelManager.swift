//
//  ModelManager.swift
//  LinkML
//
//  Created by Enryl Einhard on 30/1/2025.
//

import Foundation
import CoreML
import Collections

class LinkModelManager: ObservableObject {
    private var modelStoreDir: URL
    
    @Published var availableModels: OrderedDictionary<UUID, LinkModel>
    
    init() {
        self.modelStoreDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("CoreMLModels")
        self.availableModels = OrderedDictionary<UUID, LinkModel>()
        
        do {
            try FileManager.default.createDirectory(at: modelStoreDir, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating CoreMLModels directory: \(error.localizedDescription)")
        }
        
        initializeAllAvailableModels()
    }
    
    func initializeAllAvailableModels() {
        do {
            let filesURL = try FileManager.default.contentsOfDirectory(at: modelStoreDir, includingPropertiesForKeys: nil, options: [])
            let modelFileURLs = filesURL.filter { $0.pathExtension == "mlmodelc" }
            
            modelFileURLs.forEach { modelFileURL in
                let newLinkModel = LinkModel(name: modelFileURL.lastPathComponent , pathURL: modelFileURL)
                self.availableModels[newLinkModel.id] = newLinkModel
            }
            
        } catch {
            print("Error initializing available models. \(error.localizedDescription)")
        }
    }
    
    func loadModel(on linkModelId: UUID) {
        availableModels[linkModelId]?.loadModel()
    }
    
    func deloadModel(on linkModelId: UUID) {
        availableModels[linkModelId]?.unloadModel()
    }
    
    func getModel(from linkModelId: UUID) -> LinkModel? {
        return availableModels[linkModelId]
    }
}

