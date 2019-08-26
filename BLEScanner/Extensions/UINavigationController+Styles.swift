//
//  UINavigationController+Styles.swift
//  BLEScanner
//
//  Created by Natalia Sibaja on 2/22/18.
//  Copyright © 2018 Natalia Sibaja. All rights reserved.
//

import UIKit

extension UINavigationController {

    func customStyle() {
        let textStyles: [NSAttributedStringKey: Any] = [
            .foregroundColor: UIColor.white
        ]
        self.navigationBar.titleTextAttributes = textStyles
        self.navigationBar.barTintColor = UIColor(red:1.00, green:0.58, blue:0.00, alpha:1.0)
        self.navigationBar.tintColor = UIColor.white
    }
}
