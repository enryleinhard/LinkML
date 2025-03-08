//
//  DownloadStatus.swift
//  LinkML
//
//  Created by Enryl Einhard on 8/3/2025.
//


enum DownloadStatus: CustomStringConvertible {
    case pending
    case downloading
    case completed
    case failed
    
    var description: String {
        switch self {
        case .pending: return "Pending"
        case .downloading: return "Downloading"
        case .completed: return "Completed"
        case .failed: return "Failed"
        }
    }
}
