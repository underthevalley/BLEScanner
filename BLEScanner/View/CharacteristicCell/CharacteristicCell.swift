//
//  CharacteristicCell.swift
//  BLEScanner
//
//  Created by Natalia Sibaja on 2/18/18.
//  Copyright © 2018 Natalia Sibaja. All rights reserved.
//

import UIKit

class CharacteristicCell: UITableViewCell, NibLoadableView {

    @IBOutlet weak var uuidLbl: UILabel!
    @IBOutlet weak var accessLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!

    func configureCell(deviceCharacteristic: DeviceCharateristic) {
        self.uuidLbl.text = deviceCharacteristic.uuidFormatted
        self.accessLbl.text = (deviceCharacteristic.accessLevel.map{String($0)}).joined(separator: "/")
        self.valueLbl.text = deviceCharacteristic.value ?? "Not Available"
    }
}
