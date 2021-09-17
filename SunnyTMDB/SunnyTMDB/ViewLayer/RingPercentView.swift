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
        loadSubviews()
        setUpAndActivateLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Manual Layout

extension RingPercentView {
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePercentLabelLayerLayout()
        updateBaseRingLayerLayout()
        updateRingFillLayerLayout()
    }
    
    private func updatePercentLabelLayerLayout() {
        percentLabel.layer.cornerRadius = percentLabel.frame.size.width / 2
    }
    
    private func updateBaseRingLayerLayout() {
        baseRingLayer.path = ringLayerPath
    }
    
    private func updateRingFillLayerLayout() {
        ringFillLayer.path = ringLayerPath
    }
}

// MARK: - View Setup

extension RingPercentView {
    private var ringLayerPath: CGPath {
        let arcCenter = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        let circularPath = UIBezierPath(arcCenter: arcCenter,
                                        radius: (ringView.frame.size.width / 2) + (ringWidth / 2),
                                        startAngle: -.pi / 2,
                                        endAngle: 3 * .pi / 2,
                                        clockwise: true)
        return circularPath.cgPath
    }
    
    private func loadSubviews() {
        loadRingView()
        loadBaseRingLayer()
        loadRingFillLayer()
        loadPercentLabel()
    }
    
    private func loadRingView() {
        ringView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ringView)
    }
    
    private func loadBaseRingLayer() {
        baseRingLayer.path = ringLayerPath
        baseRingLayer.fillColor = UIColor.clear.cgColor
        baseRingLayer.lineWidth = ringWidth
        baseRingLayer.strokeColor = baseRingColor.cgColor
        ringView.layer.addSublayer(baseRingLayer)
    }
    
    private func loadRingFillLayer() {
        ringFillLayer.path = ringLayerPath
        ringFillLayer.fillColor = UIColor.clear.cgColor
        ringFillLayer.lineWidth = ringWidth
        ringFillLayer.lineCap = .round
        ringFillLayer.strokeColor = ringFillColor.cgColor
        ringView.layer.addSublayer(ringFillLayer)
    }
    
    private func loadPercentLabel() {
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(percentLabel)
    }
}

// MARK: - Auto Layout setup

extension RingPercentView {
    private var views: [String: UIView] {
        return [:]
    }
    
    private var allLayoutConstraints: [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        return constraints
    }
    
    // TODO: finish this
    private func setUpAndActivateLayoutConstraints() {
        NSLayoutConstraint.activate(allLayoutConstraints)
    }
}
