//
//  DiscoverView.swift
//  LinkML
//
//  Created by Enryl Einhard on 1/2/2025.
//

import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var bleManager: BLEManager
    
    var body: some View {
        NavigationView {
            VStack () {
                if bleManager.isBluetoothOn {
                    List(bleManager.discoveredPeripherals.elements, id: \.key) { peripheralId, peripheral  in
                        DiscoveredPeripheral(linkPeripheral: peripheral)
                            .environmentObject(bleManager)
                    }
                    .listStyle(.grouped)
                    .onAppear {
                        bleManager.startScan()
                    }
                    .onDisappear {
                        bleManager.stopScan()
                    }
                } else {
                    Text("Bluetooth is OFF")
                }
            }
            .navigationTitle("Discover")
        }
    }
}
