//
//  DiscoveredPeripheral.swift
//  LinkML
//
//  Created by Enryl Einhard on 9/3/2025.
//

import SwiftUI

struct RSSIText: View {
    var RSSI: Int
    
    private func rssiColor(for rssi: Int) -> Color {
        switch rssi {
        case -50 ... -20: return Color(red: 0, green: 0.6, blue: 0.3)
        case -60 ... -51: return Color(red: 1, green: 0.7, blue: 0)
        case -70 ... -61: return Color(red: 1, green: 0.5, blue: 0)
        case -85 ... -71: return Color(red: 1, green: 0, blue: 0)
        default:
            return Color(red: 0.7, green: 0, blue: 0.1)
        }
    }
    
    var body: some View {
        HStack {
            Text(String(RSSI) + " dBm")
                .font(.caption)
                .foregroundStyle(rssiColor(for: RSSI))
        }
    }
}

struct DiscoveredPeripheralView: View {
    @EnvironmentObject var bleManager: BLEManager
    
    let linkPeripheral: LinkPeripheral
    
    var body: some View {
        HStack {
            Image(systemName: "dot.radiowaves.forward")
            VStack (alignment: .leading) {
                Text(linkPeripheral.name)
                RSSIText(RSSI: linkPeripheral.rssi)
            }
            Spacer()
            Group {
                if linkPeripheral.connectionState == .disconnected {
                    Button("Connect") {
                        bleManager.connectToPeripheral(to: linkPeripheral)
                    }
                    
                } else if linkPeripheral.connectionState == .connected {
                    Button("Disconnect") {
                        bleManager.disconnectFromPeripheral(from: linkPeripheral)
                    }
                    .foregroundStyle(.red)
                    
                } else {
                    Button("Loading...") { }
                    .disabled(true)
                    
                }
            }
            .font(.callout)
            
        }
        .padding(4)
    }
}
