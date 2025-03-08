//
//  CharacteristicValueView.swift
//  LinkML
//
//  Created by Enryl Einhard on 8/2/2025.
//

import SwiftUI

struct CharacteristicValueView: View {
    let characteristic: LinkCharacteristic
    let trailingText: String?
    
    var body: some View {
        if characteristic.type == .string {
            if let stringValue = characteristic.getValueAsString() {
                Text("\(trailingText ?? "Value"): \(stringValue)")
            } else {
                Text("\(trailingText ?? "Value"): N/A")
            }
        } else if characteristic.type == .int {
            if let intValue = characteristic.getValueAsInt() {
                Text("\(trailingText ?? "Value"): \(intValue)")
            } else {
                Text("\(trailingText ?? "Value"): N/A")
            }
        } else {
            if let dataValue = characteristic.getValueAsData() {
                Text("\(trailingText ?? "Value"): \(dataValue.map(\.description))")
            }
        }
    }
}
