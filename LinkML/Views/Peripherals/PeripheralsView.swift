//
//  DevicesView.swift
//  LinkML
//
//  Created by Enryl Einhard on 1/2/2025.
//

import SwiftUI

struct PeripheralsView: View {
    @EnvironmentObject var linkPeripheralManager: LinkPeripheralManager
    
    var body: some View {
        NavigationView {
            VStack () {
                List(linkPeripheralManager.availablePeripherals.elements, id: \.key) { peripheralId, peripheral  in
                    NavigationLink(
                        destination: PeripheralDetailView(peripheral: peripheral)
                    ) {
                        HStack {
                            Image(systemName: "waveform")
                            VStack(
                                alignment: .leading
                            ) {
                                Text("\(peripheral.name)")
                                    .bold()
                                Text("\(peripheralId)")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Button(action: {
                                
                            }) {
                                Image(systemName: "square.and.pencil")
                            }
                        }
                        .padding(2)
                    }
                }
                .listStyle(.grouped)
            }
            .navigationTitle("Peripherals")
        }
    }
}
