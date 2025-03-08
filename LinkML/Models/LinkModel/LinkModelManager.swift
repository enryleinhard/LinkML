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
    
//    func downloadAndSaveModel(from urlString: String) async -> URL? {
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL string.")
//            return nil
//        }
//        do {
//            let (tempURL, _) = try await URLSession.shared.download(from: url)
//            let compiledURL = try await MLModel.compileModel(at: tempURL)
//            let modelName = url.lastPathComponent.replacingOccurrences(of: ".mlmodel", with: "")
//            let destURL = modelsDir.appendingPathComponent(modelName + ".mlmodelc")
//            try FileManager.default.moveItem(at: compiledURL, to: destURL)
//            return destURL
//        } catch {
//            print("Error downloading or saving model: \(error)")
//            return nil
//        }
//    }
//
//
//    func getModel(from modelName: String) -> LinkModel? {
//        return loadedModels[modelName]
//    }
}

