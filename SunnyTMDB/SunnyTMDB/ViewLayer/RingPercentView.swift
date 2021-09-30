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
    private let radiusWithoutRing: CGFloat
    
    init(baseRingColor: UIColor = UIColor.customLightGray,
         ringFillColor: UIColor = UIColor.customLightGreen,
         ringWidth: CGFloat = 5,
         radiusWithoutRing: CGFloat = 25)
    {
        self.baseRingColor = baseRingColor
        self.ringFillColor = ringFillColor
        self.ringWidth = ringWidth
        self.radiusWithoutRing = radiusWithoutRing
        super.init(frame: .zero)
        loadSubviews()
        setUpAndActivateLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - RingPercentViewProtocol Conformation

extension RingPercentView: RingPercentViewProtocol {
    var percentLabelObject: LabelProtocol {
        return percentLabel
    }
    
    func updateRingFill(percentage: Int, ringHexColorStr: String?, animated: Bool) {
        if let sureRingHexColorStr = ringHexColorStr, let newFillColor = UIColor(hexColorStr: sureRingHexColorStr) {
            ringFillColor = newFillColor
            ringFillLayer.strokeColor = ringFillColor.cgColor
        }
    
        let fillDecimal: CGFloat = CGFloat(percentage / 100)
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = 2
            animation.toValue = fillDecimal
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            ringFillLayer.add(animation, forKey: nil)
        } else {
            ringFillLayer.strokeEnd = fillDecimal
        }
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
        let dict: [String: UIView] = ["percent": percentLabel, "ring": ringView]
        return dict
    }
    
    private var allLayoutConstraints: [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        constraints += percentLabelVConstraints
        constraints += percentLabelHConstraints
        constraints += ringViewVConstraints
        constraints += ringViewHConstraints
        return constraints
    }
    
    private func setUpAndActivateLayoutConstraints() {
        NSLayoutConstraint.activate(allLayoutConstraints)
    }
    
    private var percentLabelVConstraints: [NSLayoutConstraint] {
        let height: CGFloat = radiusWithoutRing * 2
        let padding: CGFloat = ringWidth
        let VFLStr = "V:|-\(padding)-[percent(\(height))]-\(padding)-|"
        return NSLayoutConstraint.constraints(withVisualFormat: VFLStr, options: [], metrics: nil, views: views)
    }
    
    private var percentLabelHConstraints: [NSLayoutConstraint] {
        let width: CGFloat = radiusWithoutRing * 2
        let padding: CGFloat = ringWidth
        let VFLStr = "H:|-\(padding)-[percent(\(width))]-\(padding)-|"
        return NSLayoutConstraint.constraints(withVisualFormat: VFLStr, options: [], metrics: nil, views: views)
    }
    
    private var ringViewVConstraints: [NSLayoutConstraint] {
        let height: CGFloat = radiusWithoutRing * 2
        let padding: CGFloat = ringWidth
        let VFLStr = "V:|-\(padding)-[ring(\(height))]-\(padding)-|"
        return NSLayoutConstraint.constraints(withVisualFormat: VFLStr, options: [], metrics: nil, views: views)
    }
    
    private var ringViewHConstraints: [NSLayoutConstraint] {
        let width: CGFloat = radiusWithoutRing * 2
        let padding: CGFloat = ringWidth
        let VFLStr = "H:|-\(padding)-[ring(\(width))]-\(padding)-|"
        return NSLayoutConstraint.constraints(withVisualFormat: VFLStr, options: [], metrics: nil, views: views)
    }
}
