//
//  UIButtonItem+Styles.swift
//  BLEScanner
//
//  Created by Natalia Sibaja on 2/22/18.
//  Copyright © 2018 Natalia Sibaja. All rights reserved.
//

import UIKit

extension UIBarButtonItem {

    func textStyle() {
        self.setTitleTextAttributes(
            [.font: UIFont(name: "Helvetica", size: 17) ?? UIFont.systemFont(ofSize: CGFloat(17))],
            for: .normal
        )
    }
}
