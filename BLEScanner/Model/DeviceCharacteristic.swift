//
//  DeviceCharacteristic.swift
//  BLEScanner
//
//  Created by Natalia Sibaja on 2/19/18.
//  Copyright © 2018 Natalia Sibaja. All rights reserved.
//

import Foundation
import CoreBluetooth

struct DeviceCharateristic {

    var uuid: String
    var accessLevel: [String]
    var value: String?
    var uuidFormatted: String {
        get { return "0x\(uuid)" }
    }

    init(uuid: String, accessLevel: [String], value: String?) {
        self.uuid = uuid
        self.accessLevel = accessLevel
        self.value = value
    }
}
