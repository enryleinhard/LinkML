//
//  DeviceDetailView.swift
//  LinkML
//
//  Created by Enryl Einhard on 4/2/2025.
//
import SwiftUI

struct PeripheralDetailView: View {
    @EnvironmentObject var linkPeripheralManager: LinkPeripheralManager
    
    var peripheral: LinkPeripheral
    @State var isEditingCharType: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                List(peripheral.services.elements, id: \.key) { serviceId, service in
                    VStack (alignment: .leading) {
                        Text("Unknown Service").bold()
                        Text("\(serviceId)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    ForEach(service.characteristics.elements, id: \.key) { characteristicId, characteristic in
                        let charIdentifier = CharacteristicIdentifier(peripheralId: peripheral.id, serviceId: serviceId, characteristicId: characteristicId)
                        Section {
                            HStack {
                                VStack (alignment: .leading) {
                                    Text("Unknown Characteristics").bold()
                                    Group {
                                        Text("\(characteristicId)")
                                        CharacteristicValueView(characteristic: characteristic, trailingText: nil)
                                    }
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Picker("", selection: Binding(get: {
                                    return characteristic.type
                                }, set: { (newValue) in
                                    linkPeripheralManager.setCharacteristicTypeByIdentifier(identifier: charIdentifier, type: newValue)
                                })) {
                                    Group {
                                        Text("Data").tag(LinkCharacteristicValueType.data)
                                        Text("String").tag(LinkCharacteristicValueType.string)
                                        Text("Int").tag(LinkCharacteristicValueType.int)
                                    }
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                }
                                .labelsHidden()
                            }
                        }
                        .padding(.leading, 24)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle(peripheral.name)
        }
    }
}
