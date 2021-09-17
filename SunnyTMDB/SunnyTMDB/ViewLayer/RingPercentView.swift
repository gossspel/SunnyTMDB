//
//  RingPercentView.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/16/21.
//

import UIKit

class RingPercentView: UIView {
    private let baseRingLayer = CAShapeLayer()
    private let ringFillLayer = CAShapeLayer()
    private let percentLabel = UILabel()
    private let ringView = UIView()
    private let baseRingColor: UIColor
    private var ringFillColor: UIColor
    private let ringWidth: CGFloat
    private let labelRadiusWithoutRing: CGFloat
    
    init(baseRingColor: UIColor = UIColor.customLightGray,
         ringFillColor: UIColor = UIColor.customLightGreen,
         ringWidth: CGFloat = 5,
         labelRadiusWithoutRing: CGFloat = 25)
    {
        self.baseRingColor = baseRingColor
        self.ringFillColor = ringFillColor
        self.ringWidth = ringWidth
        self.labelRadiusWithoutRing = labelRadiusWithoutRing
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
