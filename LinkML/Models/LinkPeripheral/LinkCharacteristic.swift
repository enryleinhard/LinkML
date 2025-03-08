//
//  LinkCharacteristic.swift
//  LinkML
//
//  Created by Enryl Einhard on 8/2/2025.
//

import CoreBluetooth


enum LinkCharacteristicValueType: Int {
    case data = 0
    case string = 1
    case int = 2
    case double = 3
}

struct LinkCharacteristic: Identifiable {
    let id: CBUUID
    var type: LinkCharacteristicValueType = .data
    var value: Data?
    
    mutating func updateValue(newValue: Data) {
        self.value = newValue
    }
    
    mutating func setType(newType: LinkCharacteristicValueType) {
        self.type = newType
    }
    
    func getValueAsData() -> Data? {
        return self.value
    }
    
    func getValueAsString() -> String? {
        guard let value = self.value else { return nil }
        return String(data: value, encoding: .utf8)
    }
    
    func getValueAsInt() -> Int32? {
        guard let value = self.value else { return nil }
        return value.withUnsafeBytes { $0.load(as: Int32.self) }
    }
}
