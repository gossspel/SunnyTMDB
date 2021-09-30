//
//  UILabelExtensions.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/17/21.
//

import UIKit

// MARK: - LabelProtocol Conformation

extension UILabel: LabelProtocol {
    func updateLabelText(text: String?) {
        DispatchQueue.main.async {
            self.text = text
        }
    }
}
