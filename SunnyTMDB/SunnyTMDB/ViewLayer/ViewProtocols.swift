//
//  ViewProtocols.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/16/21.
//

import Foundation

protocol LabelProtocol: AnyObject {
    func updateLabelText(text: String?)
}

protocol ImageViewProtocol: AnyObject {
    func updateImageByRemoteURL(imageURLStr: String?)
}

protocol RingPercentViewProtocol: AnyObject {
    var percentLabelObject: LabelProtocol { get }
    func updateRingFill(percentage: Int, ringHexColorStr: String?, animated: Bool)
}
