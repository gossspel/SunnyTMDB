//
//  UIColorExtensions.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/16/21.
//

import UIKit

extension UIColor {
    static var customLightGray: UIColor {
        let color = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        return color
    }
    
    static var customLightGreen: UIColor {
        let color = UIColor(red: 112/255, green: 191/255, blue: 113/255, alpha: 1)
        return color
    }
    
    /// Init method to convert hex color from CSS to UIColor
    /// - Parameter hexColorStr: the hexcolor str, should include the pound key (#), and should have total of 7 chars.
    convenience init?(hexColorStr: String) {
        let red: CGFloat
        let green: CGFloat
        let blue: CGFloat
        
        guard hexColorStr.hasPrefix("#") && (hexColorStr.count == 7) else {
            return nil
        }
        
        let start = hexColorStr.index(hexColorStr.startIndex, offsetBy: 1)
        let hexColorStrWithoutPound: String = String(hexColorStr[start...])
        let scanner = Scanner(string: hexColorStrWithoutPound)
        var hexNumber: UInt64 = 0
        
        guard scanner.scanHexInt64(&hexNumber) else {
            return nil
        }
        
        // NOTE: Using bitwise AND (&), bitwise right shift (>>) operators to get RGB values
        // LINK: https://docs.swift.org/swift-book/LanguageGuide/AdvancedOperators.html#ID34
        red = CGFloat((hexNumber & 0xff0000) >> 16) / 255
        green = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
        blue = CGFloat(hexNumber & 0x0000ff) / 255
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
