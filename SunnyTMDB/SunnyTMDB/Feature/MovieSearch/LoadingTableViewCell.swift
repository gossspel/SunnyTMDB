//
//  LoadingTableViewCell.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/27/21.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {
    private var overallHeight: CGFloat = 182
    private let loadingSpinner: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        loadSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LoadingTableViewCellProtocol Conformation

extension LoadingTableViewCell: LoadingTableViewCellProtocol {
    func updateOverallHeight(height: Float) {
        self.overallHeight = CGFloat(height)
        setNeedsUpdateConstraints()
    }
}

// MARK: - UITableViewCell Overrride

extension LoadingTableViewCell {
    override func updateConstraints() {
        super.updateConstraints()
        setUpAndActivateLayoutConstraints()
    }
}

// MARK: - View Setup

extension LoadingTableViewCell {
    private func loadSubviews() {
        loadLoadingSpinner()
        
        // NOTE: Call setNeedsUpdateConstraints() after adding subviews
        // LINK: https://stackoverflow.com/a/15895048
        setNeedsUpdateConstraints()
    }
    
    private func loadLoadingSpinner() {
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        loadingSpinner.startAnimating()
        contentView.addSubview(loadingSpinner)
    }
}

// MARK: - Auto Layout Setup

extension LoadingTableViewCell {
    private var views: [String: UIView] {
        let dict: [String: UIView] = ["loadingSpinner": loadingSpinner]
        return dict
    }
    
    private var allLayoutConstraints: [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        constraints += loadingSpinnerHConstraints
        constraints += loadingSpinnerVConstraints
        return constraints
    }
    
    private var loadingSpinnerHConstraints: [NSLayoutConstraint] {
        let constraint = loadingSpinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        return [constraint]
    }
    
    private var loadingSpinnerVConstraints: [NSLayoutConstraint] {
        let constraint = loadingSpinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        return [constraint]
    }
    
    private func setUpAndActivateLayoutConstraints() {
        NSLayoutConstraint.activate(allLayoutConstraints)
    }
}
