//
//  LinkMLApp.swift
//  LinkML
//
//  Created by Enryl Einhard on 30/1/2025.
//

import SwiftUI

@main
struct LinkMLApp: App {
    @UIApplicationDelegateAdaptor(LinkMLDelegate.self) var linkMLDelegate
    
    @StateObject private var linkPeripheralManager: LinkPeripheralManager
    @StateObject private var linkModelManager: LinkModelManager
    @StateObject private var pipelineManager: PipelineManager
    @StateObject private var bleManager: BLEManager
    @StateObject private var downloadManager: DownloadManager
    
    init() {
        let downloadManager = DownloadManager()
        _downloadManager = StateObject(wrappedValue: downloadManager)
        
        let linkPeripheralManager = LinkPeripheralManager()
        _linkPeripheralManager = StateObject(wrappedValue: linkPeripheralManager)
        
        let linkModelManager = LinkModelManager()
        _linkModelManager = StateObject(wrappedValue: linkModelManager)
        
        let pipelineManager = PipelineManager(linkModelManager: linkModelManager, linkPeripheralManager: linkPeripheralManager)
        _pipelineManager = StateObject(wrappedValue: pipelineManager)
        
        let bleManager = BLEManager(linkPeripheralManager: linkPeripheralManager, pipelineManager: pipelineManager)
        _bleManager = StateObject(wrappedValue: bleManager)
        
        linkMLDelegate.downloadManager = downloadManager
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(downloadManager)
                .environmentObject(bleManager)
                .environmentObject(linkPeripheralManager)
                .environmentObject(linkModelManager)
                .environmentObject(pipelineManager)
        }
        
    }
}
