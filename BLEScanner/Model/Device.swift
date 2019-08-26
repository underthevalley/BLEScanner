//
//  Device.swift
//  BLEScanner
//
//  Created by Natalia Sibaja on 2/19/18.
//  Copyright © 2018 Natalia Sibaja. All rights reserved.
//

import Foundation
import CoreBluetooth

struct Device {

    var name: String!
    var manufacturerData: String?
    var uuid: String!
    var characteristic: [DeviceCharateristic]!
    private(set) var peripheral: CBPeripheral!
    private var advertisementData: [String: Any]!

    var isConnectable: Bool {
        guard let connectable = advertisementData[CBAdvertisementDataIsConnectable] as? NSNumber else {
            return false
        }

        return connectable.boolValue
    }

    init(peripheral: CBPeripheral, advertisementData: [String: Any]) {
        self.name = peripheral.name ?? "Not Available"
        self.uuid = peripheral.identifier.uuidString
        self.peripheral = peripheral
        self.advertisementData = advertisementData
        self.characteristic = []
        if let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? String {
            self.manufacturerData = manufacturerData
        }
    }
}
