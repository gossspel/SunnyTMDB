//
//  UIImageViewExtensions.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/15/21.
//

import UIKit
import Kingfisher

// MARK: - ImageViewProtocol Conformation

extension UIImageView: ImageViewProtocol {
    func updateImageByRemoteURL(imageURLStr: String?) {
        if let sureImageURLStr = imageURLStr {
            let imageURL = URL(string: sureImageURLStr)
            self.kf.setImage(with: imageURL)
        } else {
            self.image = nil
        }
    }
}
