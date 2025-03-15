//
//  ConnectedPeripheralsView.swift
//  LinkML
//
//  Created by Enryl Einhard on 1/2/2025.
//

import SwiftUI

struct ConnectedPeripheralsView: View {
    @EnvironmentObject var linkPeripheralManager: LinkPeripheralManager
    
    var body: some View {
        NavigationView {
            VStack () {
                List(linkPeripheralManager.availablePeripherals.elements, id: \.key) { peripheralId, peripheral  in
                    NavigationLink(
                        destination: ConnectedPeripheralDetailView(peripheral: peripheral)
                    ) {
                        ConnectedPeripheralView(linkPeripheral: peripheral)
                    }
                }
                .listStyle(.grouped)
            }
            .navigationTitle("Peripherals")
        }
    }
}
