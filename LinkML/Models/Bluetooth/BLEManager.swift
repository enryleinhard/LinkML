//
//  BLEManager.swift
//  LinkML
//
//  Created by Enryl Einhard on 1/2/2025.
//

import Foundation
import CoreBluetooth
import Collections

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private var centralManager: CBCentralManager!
    private var linkPeripheralManager: LinkPeripheralManager!
    private var pipelineManager: PipelineManager!
    
    @Published var discoveredPeripherals: OrderedDictionary<UUID, LinkPeripheral> = [:]
    
    init(linkPeripheralManager: LinkPeripheralManager, pipelineManager: PipelineManager) {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        self.linkPeripheralManager = linkPeripheralManager
        self.pipelineManager = pipelineManager
    }
    
    // MARK: - Central Manager Delegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn) {
            print("Start Scanning ...")
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Stop Scanning ...")
            centralManager.stopScan()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let newPeripheral = LinkPeripheral(id: peripheral.identifier, cbPeripheral: peripheral, rssi: RSSI.intValue)
        if let existingPeripheral = discoveredPeripherals[newPeripheral.id] {
            discoveredPeripherals[existingPeripheral.id]?.rssi = RSSI.intValue
        } else {
            discoveredPeripherals[newPeripheral.id] = newPeripheral
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected: \(peripheral.name ?? "N/A")")
        
        let peripheralId = peripheral.identifier
        guard let linkPeripheral = discoveredPeripherals[peripheralId] else { return }
        linkPeripheralManager.addPeripheral(peripheral: linkPeripheral)
        
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: (any Error)?) {
        print("Failed to connect...")
        if let peripheralName = peripheral.name {
            print("Failed to connect to \(peripheralName)")
        } else {
            print("Failed to connect to Unknown")
        }
        if let error = error {
            print("Failed to connect, error: \(error)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: (any Error)?) {
        if let error = error {
            print("Failed to disconnect, error: \(error)")
        }
        
        print("Disconnected: \(peripheral.name ?? "N/A")")
        
        let peripheralId = peripheral.identifier
        linkPeripheralManager.removePeripheral(for: peripheralId)
    }
    
    // MARK: - Peripheral Delegate
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        if let error = error {
                print("Error discovering services: \(error.localizedDescription)")
                return
            }
        let peripheralId = peripheral.identifier
        
        if let services = peripheral.services {
            for service in services {
                print("Discovered serviceId: \(service.uuid)")
                
                let newService = LinkService(id: service.uuid)
                linkPeripheralManager.addService(for: peripheralId, service: newService)
                
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        if let error = error {
                print("Error discovering characteristics: \(error.localizedDescription)")
                return
            }
        
        let peripheralId = peripheral.identifier
        let serviceId = service.uuid
        
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                print("Discovered characteristicId: \(characteristic.uuid)")
                
                let newCharacteristic = LinkCharacteristic(id: characteristic.uuid)
                linkPeripheralManager.addCharacteristic(for: peripheralId, serviceId: serviceId, characteristic: newCharacteristic)
                
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error updating value for characteristic: \(error.localizedDescription)")
            return
        }   
        
        let peripheralId = peripheral.identifier
        guard let serviceId = characteristic.service?.uuid else { return }
        
        if let data = characteristic.value {
            linkPeripheralManager.updateCharacteristicValue(for: peripheralId, serviceId: serviceId, characteristicId: characteristic.uuid, value: data)
            pipelineManager.executePipeline(
                characteristicIdentifier: CharacteristicIdentifier(peripheralId: peripheralId, serviceId: serviceId, characteristicId: characteristic.uuid)
            )
        }
    }
    
    // MARK: - Manager
    
    func startScan() {
        print("Start scanning...")
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScan() {
        print("Stop scanning...")
        centralManager.stopScan()
    }
    
    // MARK: - Peripheral
    
    func connectToPeripheral(to peripheral: LinkPeripheral) {
        guard let cbPeripheral = centralManager.retrievePeripherals(withIdentifiers: [peripheral.id]).first else {
            print("Fail to find!")
            return
        }
        cbPeripheral.delegate = self
        centralManager.connect(cbPeripheral)
    }
    
    func disconnectFromPeripheral(from peripheral: LinkPeripheral) {
        guard let cbPeripheral = centralManager.retrievePeripherals(withIdentifiers: [peripheral.id]).first else {
            print("Fail to find!")
            return
        }
        cbPeripheral.delegate = nil
        centralManager.cancelPeripheralConnection(cbPeripheral)
    }
}
