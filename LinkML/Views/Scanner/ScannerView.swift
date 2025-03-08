//
//  ScannerView.swift
//  LinkML
//
//  Created by Enryl Einhard on 1/2/2025.
//

import SwiftUI

struct ScannerView: View {
    @EnvironmentObject var bleManager: BLEManager
    
    var body: some View {
        NavigationView {
            VStack () {
                List(bleManager.discoveredPeripherals.elements, id: \.key) { peripheralId, peripheral  in
                    HStack {
                        Image(systemName: "waveform")
                        VStack(
                            alignment: .leading
                        ) {
                            Text("\(peripheral.name)")
                                .bold()
                            Text("RSSI: \(peripheral.rssi)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button(action: {
                            
                            if (peripheral.connectionState == .disconnected) {  
                                bleManager.connectToPeripheral(to: peripheral)
                            } else if (peripheral.connectionState == .connected) {
                                bleManager.disconnectFromPeripheral(from: peripheral)
                            }
                            
                        }) {

                            if (peripheral.connectionState == .disconnected) {
                                Text("Connect")
                            } else if (peripheral.connectionState == .connected) {
                                Text("Disconnect")
                                    .foregroundStyle(.red)
                            } else {
                                Text("Loading...")
                                    .foregroundStyle(.secondary)
                            }
                            
                        }
                        .disabled(
                            peripheral.connectionState == .disconnecting || peripheral.connectionState == .connecting
                        )
                    }
                    .padding(2)
                    
                }.listStyle(.grouped)
            }
            .navigationTitle("Discover Peripherals")
        }
    }
}

#Preview {
    ScannerView()
}
