//
//  ModelManager.swift
//  LinkML
//
//  Created by Enryl Einhard on 30/1/2025.
//

import Foundation
import CoreML
import Collections

class LinkModelManager: ObservableObject, DownloadDelegate {
    private var modelStoreDir: URL
    
    private var downloadManager: DownloadManager
    private var downloadableTaskToModelMapper: [UUID: UUID] = [:]
    
    @Published var availableModels: OrderedDictionary<UUID, LinkModel>
    
    init(downloadManager: DownloadManager) {
        self.downloadManager = downloadManager
        self.modelStoreDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("CoreMLModels")
        
        self.availableModels = OrderedDictionary<UUID, LinkModel>()
        do {
            try FileManager.default.createDirectory(at: modelStoreDir, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating CoreMLModels directory: \(error.localizedDescription)")
        }
        initializeAllAvailableModels()
        downloadManager.downloadDelegate = self
    }
    
    func initializeAllAvailableModels() {
        do {
            let filesURL = try FileManager.default.contentsOfDirectory(at: modelStoreDir, includingPropertiesForKeys: nil, options: [])
            filesURL.forEach { modelFileURL in
                let newLinkModel = LinkModel(name: modelFileURL.lastPathComponent , pathURL: modelFileURL)
                self.availableModels[newLinkModel.id] = newLinkModel
                self.loadModel(on: newLinkModel.id)
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
    
    // MARK: - Download Methods
    
    func downloadModel(modelName: String, modelURL: URL) {
        let downloadableTaskId = downloadManager.addDownloadTask(downloadURL: modelURL)
        var newLinkModel = LinkModel(name: modelName)
        newLinkModel.downloadProgress = Double.zero
        DispatchQueue.main.async {
            self.availableModels[newLinkModel.id] = newLinkModel
        }
        self.downloadableTaskToModelMapper[downloadableTaskId] = newLinkModel.id
    }
    
    func didFinishDownload(linkDownloadTaskId: UUID, locationURL: URL) {
        let linkModelId = self.downloadableTaskToModelMapper[linkDownloadTaskId]
        guard let linkModelId else {
            return
        }
        
        MLModel.compileModel(at: locationURL) { compiledURL in
            do {
                let safeCompiledURL = try compiledURL.get()
                
                let linkModelName = self.availableModels[linkModelId]?.name ?? "Unknown"
                let destURL = self.modelStoreDir.appendingPathComponent(linkModelName)
                
                try FileManager.default.moveItem(at: safeCompiledURL, to: destURL)
                try FileManager.default.removeItem(at: locationURL)
                
                DispatchQueue.main.async {
                    self.availableModels[linkModelId]?.downloadProgress = nil
                    self.availableModels[linkModelId]?.pathURL = destURL
                    self.availableModels[linkModelId]?.loadModel()
                }
                
            } catch {
                print("ERR: Model compilation failed: , \(error)")
            }
        }
    }
    
    func didProgressDownload(linkDownloadTaskId: UUID, downloadProgress: Double) {
        let linkModelId = self.downloadableTaskToModelMapper[linkDownloadTaskId]
        guard let linkModelId else {
            return
        }
        DispatchQueue.main.async {
            self.availableModels[linkModelId]?.downloadProgress = downloadProgress
        }
    }
    
    func didFailDownload(linkDownloadTaskId: UUID, error: any Error) {
        
    }
}

