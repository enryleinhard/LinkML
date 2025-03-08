//
//  ContentView.swift
//  LinkML
//
//  Created by Enryl Einhard on 30/1/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var linkPeripheralManager: LinkPeripheralManager
    @StateObject private var linkModelManager: LinkModelManager
    @StateObject private var pipelineManager: PipelineManager
    @StateObject private var bleManager: BLEManager
    
    init() {
        let linkPeripheralManager = LinkPeripheralManager()
        _linkPeripheralManager = StateObject(wrappedValue: linkPeripheralManager)
        
        let linkModelManager = LinkModelManager()
        _linkModelManager = StateObject(wrappedValue: linkModelManager)
        
        let pipelineManager = PipelineManager(linkModelManager: linkModelManager, linkPeripheralManager: linkPeripheralManager)
        _pipelineManager = StateObject(wrappedValue: pipelineManager)
        
        let bleManager = BLEManager(linkPeripheralManager: linkPeripheralManager, pipelineManager: pipelineManager)
        _bleManager = StateObject(wrappedValue: bleManager)
        
    }
    
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
    }
}
