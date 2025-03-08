//
//  LinkPeripheralManager.swift
//  LinkML
//
//  Created by Enryl Einhard on 4/2/2025.
//

import Foundation
import CoreBluetooth
import Collections

struct CharacteristicIdentifier: Hashable {
    let peripheralId: UUID
    let serviceId: CBUUID
    let characteristicId: CBUUID
    var id: String { "\(peripheralId.uuidString):\(serviceId.uuidString):\(characteristicId.uuidString)" }
}

class LinkPeripheralManager: ObservableObject {
    @Published var availablePeripherals: OrderedDictionary<UUID, LinkPeripheral> = [:]
    
    // MARK: - Peripheral
    
    func addPeripheral(peripheral: LinkPeripheral) {
        availablePeripherals[peripheral.id] = peripheral
    }
    
    func removePeripheral(for peripheralId: UUID) {
        availablePeripherals.removeValue(forKey: peripheralId)
    }
    
    // MARK: - Service
    
    func addService(for peripheralId: UUID, service: LinkService) {
        availablePeripherals[peripheralId]?.services[service.id] = service
    }
    
    // MARK: - Characteristic
    
    func getCharacteristicByIdentifier(identifier: CharacteristicIdentifier) -> LinkCharacteristic? {
        return availablePeripherals[identifier.peripheralId]?.services[identifier.serviceId]?.characteristics[identifier.characteristicId]
    }
    
    func setCharacteristicTypeByIdentifier(identifier: CharacteristicIdentifier, type: LinkCharacteristicValueType) {
        availablePeripherals[identifier.peripheralId]?.services[identifier.serviceId]?.characteristics[identifier.characteristicId]?.type = type
    }
    
    func addCharacteristic(for peripheralId: UUID, serviceId: CBUUID, characteristic: LinkCharacteristic) {
        availablePeripherals[peripheralId]?.services[serviceId]?.characteristics[characteristic.id] = characteristic
    }
    
    func updateCharacteristicValue(for peripheralId: UUID, serviceId: CBUUID, characteristicId: CBUUID, value: Data) {
        availablePeripherals[peripheralId]?.services[serviceId]?.characteristics[characteristicId]?.value = value
    }
    
    func getAllCharacteristic() -> [CharacteristicIdentifier] {
        return availablePeripherals.values.flatMap { peripheral in
            peripheral.services.values.flatMap { service in
                service.characteristics.keys.map { characteristicId in
                    CharacteristicIdentifier(peripheralId: peripheral.id, serviceId: service.id, characteristicId: characteristicId)
                }
            }
        }
    }
    
}
