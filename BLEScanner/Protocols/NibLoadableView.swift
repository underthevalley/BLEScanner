//
//  NibLoadableView.swift
//  BLEScanner
//
//  Created by Natalia Sibaja on 2/19/18.
//  Copyright © 2018 Natalia Sibaja. All rights reserved.
//

import UIKit

protocol NibLoadableView: class {}

extension NibLoadableView where Self: UIView {

    static var nibName: String {
        return String(describing: self)
    }
}
