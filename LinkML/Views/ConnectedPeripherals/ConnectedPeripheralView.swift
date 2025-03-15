//
//  ConnectedPeripheralView.swift
//  LinkML
//
//  Created by Enryl Einhard on 9/3/2025.
//

import SwiftUI

struct ConnectedPeripheralView: View {
    let linkPeripheral: LinkPeripheral
    
    var body: some View {
        HStack {
            Image(systemName: "link")
            VStack (alignment: .leading) {
                Text(linkPeripheral.name)
                Text(linkPeripheral.id.uuidString)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(4)
    }
}
