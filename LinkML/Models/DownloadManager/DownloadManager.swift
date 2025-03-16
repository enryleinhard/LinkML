//
//  DownloadManager.swift
//  LinkML
//
//  Created by Enryl Einhard on 8/3/2025.
//

import Foundation

class DownloadManager: NSObject, ObservableObject, URLSessionDownloadDelegate {
    @Published var linkDownloadTasks: [LinkDownloadTask] = []
    
    private var urlSession: URLSession!
    private var urlDownloadTaskMapper: [Int: UUID] = [:]
    
    let sessionIdentifier = "com.LinkML.backgroundSession"
    var backgroundSessionCompletionHandler: (() -> Void)?
    
    var downloadDelegate: DownloadDelegate?
        
    override init() {
        super.init()
        let urlSessionConfiguration = URLSessionConfiguration.background(withIdentifier: sessionIdentifier)
        urlSessionConfiguration.sessionSendsLaunchEvents = true
        urlSession = URLSession(configuration: urlSessionConfiguration, delegate: self, delegateQueue: nil)
    }
    
    func addDownloadTask(downloadURL: URL) -> UUID {
        var linkDownloadTask = LinkDownloadTask(downloadURL: downloadURL, downloadStatus: .pending)
        let urlDownloadTask = urlSession.downloadTask(with: downloadURL)
        
        linkDownloadTasks.append(linkDownloadTask)
        urlDownloadTaskMapper[urlDownloadTask.taskIdentifier] = linkDownloadTask.id
        
        urlDownloadTask.resume()
        linkDownloadTask.startDownload()
        
        return linkDownloadTask.id
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let urlDownloadTaskId = urlDownloadTaskMapper[downloadTask.taskIdentifier],
              let linkDownloadTaskId = linkDownloadTasks.firstIndex(where: { $0.id == urlDownloadTaskId }) else {
            return
        }
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            self.linkDownloadTasks[linkDownloadTaskId].downloadProgress = progress
            self.downloadDelegate?.didProgressDownload(linkDownloadTaskId: self.linkDownloadTasks[linkDownloadTaskId].id, downloadProgress: progress)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let urlDownloadTaskId = urlDownloadTaskMapper[downloadTask.taskIdentifier],
              let linkDownloadTaskId = linkDownloadTasks.firstIndex(where: { $0.id == urlDownloadTaskId }) else {
            return
        }
        
        let linkDownloadTask = self.linkDownloadTasks[linkDownloadTaskId]
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsURL.appendingPathComponent(linkDownloadTask.downloadURL.lastPathComponent)
        
        do {
            try FileManager.default.moveItem(at: location, to: destinationURL)
            DispatchQueue.main.async {
                self.linkDownloadTasks[linkDownloadTaskId].completeDownload(at: destinationURL)
                self.downloadDelegate?.didFinishDownload(linkDownloadTaskId: self.linkDownloadTasks[linkDownloadTaskId].id, locationURL: destinationURL)
            }
        } catch {
            print("Error: \(error)")
            DispatchQueue.main.async {
                self.linkDownloadTasks[linkDownloadTaskId].failDownload()
            }
        }
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            guard let urlDownloadTaskId = urlDownloadTaskMapper[task.taskIdentifier],
                  let linkDownloadTaskId = linkDownloadTasks.firstIndex(where: { $0.id == urlDownloadTaskId }) else {
                return
            }
            DispatchQueue.main.async {
                self.linkDownloadTasks[linkDownloadTaskId].failDownload()
            }
        }
        urlDownloadTaskMapper.removeValue(forKey: task.taskIdentifier)
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        self.backgroundSessionCompletionHandler?()
        self.backgroundSessionCompletionHandler = nil
    }
}
