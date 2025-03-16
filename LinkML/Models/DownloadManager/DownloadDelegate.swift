//
//  DownloadDelegate.swift
//  LinkML
//
//  Created by Enryl Einhard on 15/3/2025.
//

import Foundation

protocol DownloadDelegate: AnyObject {
    func didFinishDownload(linkDownloadTaskId: UUID, locationURL: URL)
    func didProgressDownload(linkDownloadTaskId: UUID, downloadProgress: Double)
    func didFailDownload(linkDownloadTaskId: UUID, error: Error)
}
