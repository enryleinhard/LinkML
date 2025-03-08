//
//  DownloadableTask.swift
//  LinkML
//
//  Created by Enryl Einhard on 8/3/2025.
//

import Foundation

struct DownloadableTask: Identifiable {
    let id = UUID()
    let downloadURL: URL
    var downloadStatus: DownloadStatus = .pending
    var downloadProgress: Double = 0.0
    var locationURL: URL?
    
    mutating func startDownload() {
        downloadStatus = .downloading
    }
    
    mutating func completeDownload(at destinationURL: URL) {
        locationURL = destinationURL
        downloadProgress = 1.0
        downloadStatus = .completed
    }
    
    mutating func failDownload() {
        downloadStatus = .failed
        downloadProgress = 0.0
    }
}
