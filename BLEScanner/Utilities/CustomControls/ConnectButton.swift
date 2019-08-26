//
//  ConnectButton.swift
//  BLEScanner
//
//  Created by Natalia Sibaja on 2/21/18.
//  Copyright © 2018 Natalia Sibaja. All rights reserved.
//

import UIKit

@IBDesignable class ConnectButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
}
