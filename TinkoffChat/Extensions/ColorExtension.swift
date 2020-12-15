//
//  ColorExtension.swift
//  TinkoffChat
//
//  Created by Ildar on 9/29/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
}
