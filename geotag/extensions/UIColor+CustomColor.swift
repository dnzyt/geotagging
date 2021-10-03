//
//  UIColor+CustomColor.swift
//  geotag
//
//  Created by Ningze Dai on 10/2/21.
//

import UIKit

extension UIColor {
    convenience init(rgb: UInt) {
           self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgb & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
        }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let hbOrange = UIColor(r: 255, g: 165, b: 0)

}
