//
//  DeviceConnectionDelegate.swift
//  BLEScanner
//
//  Created by Natalia Sibaja on 2/19/18.
//  Copyright © 2018 Natalia Sibaja. All rights reserved.
//

import Foundation

protocol DeviceConnectionDelegate: class {
    func connectDevice(device: Device)
}
