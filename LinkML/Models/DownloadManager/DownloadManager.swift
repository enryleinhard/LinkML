//
//  DownloadManager.swift
//  LinkML
//
//  Created by Enryl Einhard on 8/3/2025.
//

import Foundation

class DownloadManager: NSObject, ObservableObject, URLSessionDownloadDelegate {
    @Published var downloadableTasks: [DownloadableTask] = []
    
    private var urlSession: URLSession!
    private var urlSessionTaskMapper: [Int: UUID] = [:]
    
    let sessionIdentifier = "com.LinkML.backgroundSession"
    var backgroundSessionCompletionHandler: (() -> Void)?
        
    override init() {
        super.init()
        let urlSessionConfiguration = URLSessionConfiguration.background(withIdentifier: sessionIdentifier)
        urlSessionConfiguration.sessionSendsLaunchEvents = true
        urlSession = URLSession(configuration: urlSessionConfiguration, delegate: self, delegateQueue: nil)
    }
    
    func addDownloadTask(downloadURL: URL) {
        var downloadableTask = DownloadableTask(downloadURL: downloadURL, downloadStatus: .pending)
        let urlSessionTask = urlSession.downloadTask(with: downloadURL)
        
        downloadableTasks.append(downloadableTask)
        urlSessionTaskMapper[urlSessionTask.taskIdentifier] = downloadableTask.id
        
        urlSessionTask.resume()
        downloadableTask.startDownload()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let downloadTaskId = urlSessionTaskMapper[downloadTask.taskIdentifier],
              let downloadTaskIdx = downloadableTasks.firstIndex(where: { $0.id == downloadTaskId }) else {
            return
        }
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            self.downloadableTasks[downloadTaskIdx].downloadProgress = progress
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let downloadTaskId = urlSessionTaskMapper[downloadTask.taskIdentifier],
              let downloadTaskIdx = downloadableTasks.firstIndex(where: { $0.id == downloadTaskId }) else {
            return
        }
        
        let downloadableTask = self.downloadableTasks[downloadTaskIdx]
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsURL.appendingPathComponent(downloadableTask.downloadURL.lastPathComponent)
        
        do {
            try FileManager.default.moveItem(at: location, to: destinationURL)
            DispatchQueue.main.async {
                self.downloadableTasks[downloadTaskIdx].completeDownload(at: destinationURL)
            }
        } catch {
            print("Error: \(error)")
            DispatchQueue.main.async {
                self.downloadableTasks[downloadTaskIdx].failDownload()
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            guard let downloadTaskId = urlSessionTaskMapper[task.taskIdentifier],
                  let downloadTaskIdx = downloadableTasks.firstIndex(where: { $0.id == downloadTaskId }) else {
                return
            }
            DispatchQueue.main.async {
                self.downloadableTasks[downloadTaskIdx].failDownload()
            }
        }
        urlSessionTaskMapper.removeValue(forKey: task.taskIdentifier)
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        self.backgroundSessionCompletionHandler?()
        self.backgroundSessionCompletionHandler = nil
    }
}
