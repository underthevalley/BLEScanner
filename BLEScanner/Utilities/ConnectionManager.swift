//
//  ConnectionManager.swift
//  BLEScanner
//
//  Created by Natalia Sibaja on 2/18/18.
//  Copyright © 2018 Natalia Sibaja. All rights reserved.
//

import Foundation
import CoreBluetooth
import RxSwift

class ConnectionManager: NSObject {

    static let share = ConnectionManager()
    var centralManager: CBCentralManager?
    var publishDevice: PublishSubject<Device>!
    var publishDeviceCharacteristic: PublishSubject<DeviceCharateristic>!
    var connectionState: PublishSubject<CBManagerState>!
    var currentCentralState: CBManagerState?
    var currentDeviceCharacteristics: [DeviceCharateristic]!

    private override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager?.delegate = self
        publishDevice = PublishSubject<Device>()
        publishDeviceCharacteristic = PublishSubject<DeviceCharateristic>()
        connectionState = PublishSubject<CBManagerState>()
        currentDeviceCharacteristics = []
    }

    func connect(peripheral: CBPeripheral) {
        currentDeviceCharacteristics.removeAll()
        centralManager?.connect(peripheral, options: nil)
    }

    func scanDevices() {
        if currentCentralState == CBManagerState.poweredOn {
            centralManager?.scanForPeripherals(withServices: nil)
        }
    }

    func stopScanDevices() {
        centralManager?.stopScan()
    }
}

// MARK: CBCentralManagerDelegate
extension ConnectionManager: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
        }
        connectionState.onNext(central.state)
        currentCentralState = central.state
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let device = Device(peripheral: peripheral, advertisementData: advertisementData)
        device.peripheral.delegate = self
        publishDevice.onNext(device)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
}

// MARK: CBPeripheralDelegate
extension ConnectionManager: CBPeripheralDelegate {

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        services.forEach { service in
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.uuid.uuidString.starts(with: "2A") {
                var accessValues = [String]()

                if characteristic.properties.contains(.read) {
                    accessValues.append("Read")
                    peripheral.readValue(for: characteristic)
                }

                if characteristic.properties.contains(.write) {
                    accessValues.append("Write")
                }

                let newCharacteristic = DeviceCharateristic(uuid: characteristic.uuid.uuidString, accessLevel: accessValues, value: nil)
                currentDeviceCharacteristics.append(newCharacteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if var currentCharacteristic = currentDeviceCharacteristics.first(where: { $0.uuid == characteristic.uuid.uuidString }) {
            if let data = characteristic.value {
                currentCharacteristic.value = String(data: data, encoding: .utf8)
            }

            publishDeviceCharacteristic.onNext(currentCharacteristic)
        }
    }
}
