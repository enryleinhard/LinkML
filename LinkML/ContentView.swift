//
//  ContentView.swift
//  LinkML
//
//  Created by Enryl Einhard on 30/1/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var linkPeripheralManager: LinkPeripheralManager
    @EnvironmentObject var linkModelManager: LinkModelManager
    @EnvironmentObject var pipelineManager: PipelineManager
    @EnvironmentObject var bleManager: BLEManager
    @EnvironmentObject var downloadManager: DownloadManager
    
    @State var selectedTab: Int = 0
    
    var body: some View {
        TabView (selection: $selectedTab) {
            ScannerView()
                .tabItem {
                    Image(systemName: "waveform.badge.magnifyingglass")
                    Text("Discover")
                }
                .tag(0)
            PeripheralsView()
                .tabItem {
                    Image(systemName: "wave.3.forward.circle")
                    Text("Devices")
                }
                .tag(1)
            ModelsView()
                .tabItem {
                    Image(systemName: "folder")
                    Text("Models")
                }
                .tag(2)
            PipelinesView()
                .tabItem {
                    Image(systemName: "bolt.horizontal")
                    Text("Pipelines")
                }
                .tag(3)
        }
        .environmentObject(bleManager)
        .environmentObject(linkPeripheralManager)
        .environmentObject(linkModelManager)
        .environmentObject(pipelineManager)
        .environmentObject(downloadManager)
    }
}
