//
//  UITableViewExt.swift
//  BLEScanner
//
//  Created by Natalia Sibaja on 2/22/18.
//  Copyright © 2018 Natalia Sibaja. All rights reserved.
//

import UIKit

extension UITableView {

    func registerCell<T: UITableViewCell>(_: T.Type) where T: NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
}

extension UITableViewCell: ReusableView { }
