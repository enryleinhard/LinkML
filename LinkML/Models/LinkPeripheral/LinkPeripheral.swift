//
//  LinkPeripheral.swift
//  LinkML
//
//  Created by Enryl Einhard on 1/2/2025.
//

import Foundation
import CoreBluetooth
import Collections

struct LinkPeripheral: Identifiable {
    let id: UUID
    let cbPeripheral: CBPeripheral
    
    var rssi: Int
    var services: OrderedDictionary<CBUUID, LinkService> = [:]
    
    var name: String { cbPeripheral.name ?? "N/A" }
    var connectionState: CBPeripheralState { cbPeripheral.state }
    
    func getAllCharacteristicUUID() -> [CBUUID] {
        return services.values.flatMap { $0.getAllCharacteristicUUID() }
    }
}

struct LinkService: Identifiable {
    let id: CBUUID
    var characteristics: OrderedDictionary<CBUUID, LinkCharacteristic> = [:]
    
    func getAllCharacteristicUUID() -> [CBUUID] {
        return Array<CBUUID>(self.characteristics.keys)
    }
}


