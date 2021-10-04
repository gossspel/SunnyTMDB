//
//  UIImageViewExtensions.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/15/21.
//

import UIKit
import Kingfisher

// MARK: - ImageViewProtocol Conformation

// TODO: ditch Kingfisher and optimize the image caching logic on our own to make scrolling smooth on old devices.

extension UIImageView: ImageViewProtocol {
    func updateImageByRemoteURL(imageURLStr: String?) {
        if let sureImageURLStr = imageURLStr {
            let imageURL = URL(string: sureImageURLStr)
            DispatchQueue.main.async {
                self.kf.setImage(with: imageURL,
                                 options: [.processor(DownsamplingImageProcessor(size: self.bounds.size)),
                                           .scaleFactor(UIScreen.main.scale),
                                           .cacheOriginalImage])
            }
        } else {
            DispatchQueue.main.async {
                self.image = nil
            }
        }
    }
}
