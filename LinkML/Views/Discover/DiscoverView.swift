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
                List(bleManager.discoveredPeripherals.elements, id: \.key) { peripheralId, peripheral  in
                    DiscoveredPeripheral(linkPeripheral: peripheral)
                        .environmentObject(bleManager)
                }.listStyle(.grouped)
            }
            .navigationTitle("Discover")
        }
    }
}

//#Preview {
//    DiscoverView()
//}
