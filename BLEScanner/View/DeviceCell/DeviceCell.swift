//
//  DeviceCell.swift
//  BLEScanner
//
//  Created by Natalia Sibaja on 2/19/18.
//  Copyright © 2018 Natalia Sibaja. All rights reserved.
//

import UIKit
import CoreBluetooth

class DeviceCell: UITableViewCell, NibLoadableView {

    @IBOutlet weak var deviceNameLbl: UILabel!
    @IBOutlet weak var deviceStateLbl: UILabel!
    @IBOutlet weak var connectBtn: ConnectButton!

    var currentDevice: Device!
    weak var delegate: DeviceConnectionDelegate?

    func configureCell(device: Device) {
        self.deviceNameLbl.text = device.name
        self.deviceStateLbl.text = device.isConnectable ? "Connectable" : "Non-Connectable"
        self.connectBtn.isHidden = !device.isConnectable
        currentDevice = device
    }

    @IBAction func connectBtnPressed(_ sender: UIButton) {
        delegate?.connectDevice(device: currentDevice)
    }
}
