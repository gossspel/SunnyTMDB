//
//  UIImageViewExtensions.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/15/21.
//

import UIKit
import Kingfisher

// TODO: if we need to make image loading even faster/scrolling smoother on older iOS devices, ditch Kingfisher and
// optimize the image caching logic on our own using NSCache.

// MARK: - Method to update UIImageView

extension UIImageView {
    func updateImageByRemoteURL(imageURLStr: String?) {
        if let sureImageURLStr = imageURLStr {
            let imageURL = URL(string: sureImageURLStr)
            
            // NOTE: dispatching the Kingfisher setImage method in main queue async block yields quicker callback in
            // comparison to executing in the current main thread.
            DispatchQueue.main.async {
                self.kf.setImage(with: imageURL,
                                 options: [.processor(DownsamplingImageProcessor(size: self.bounds.size)),
                                           .scaleFactor(UIScreen.main.scale),
                                           .cacheOriginalImage])
            }
        } else {
            self.image = nil
        }
    }
}
