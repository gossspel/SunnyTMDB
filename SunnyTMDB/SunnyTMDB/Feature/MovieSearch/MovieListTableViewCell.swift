//
//  MovieListTableViewCell.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/13/21.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {
    private let posterImageView: UIImageView = UIImageView()
    private let ratingRingView: RingPercentView = RingPercentView()
    private let titleLabel: UILabel = UILabel()
    private let dateLabel: UILabel = UILabel()
    private var outerPadding: CGFloat = 16
    private var innerPadding: CGFloat = 8
    private var posterHeight: CGFloat = 150
    
    private var posterWidth: CGFloat {
        return posterHeight * 2 / 3
    }
    
    private var titleHeight: CGFloat {
        return posterHeight - innerPadding - ratingHeight
    }
    
    private var ratingHeight: CGFloat {
        return posterHeight / 3
    }
    
    private var ratingWidth: CGFloat {
        return ratingHeight
    }
    
    private var dateHeight: CGFloat {
        return ratingHeight
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        loadSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - MovieListTableViewCellProtocol Conformation

extension MovieListTableViewCell: MovieListTableViewCellProtocol {
    var titleLabelObject: LabelProtocol {
        return titleLabel
    }
    
    var dateLabelObject: LabelProtocol {
        return dateLabel
    }
    
    var posterImageViewObject: ImageViewProtocol {
        return posterImageView
    }
    
    var ratingRingViewObject: RingPercentViewProtocol {
        return ratingRingView
    }
    
    func updateOuterPadding(padding: Float) {
        self.outerPadding = CGFloat(padding)
        setNeedsUpdateConstraints()
    }
    
    func updateInnerPadding(padding: Float) {
        self.innerPadding = CGFloat(padding)
        setNeedsUpdateConstraints()
    }
    
    func updatePosterHeight(height: Float) {
        self.posterHeight = CGFloat(height)
        setNeedsUpdateConstraints()
    }
}

// MARK: - UITableViewCell Overrride

extension MovieListTableViewCell {    
    override func updateConstraints() {
        super.updateConstraints()
        setUpAndActivateLayoutConstraints()
    }
}

// MARK: - View Setup

extension MovieListTableViewCell {
    private func loadSubviews() {
        loadPosterImageView()
        loadRatingRingView()
        loadTitleLabel()
        loadDateLabel()
        
        // NOTE: Call setNeedsUpdateConstraints() after adding subviews
        // LINK: https://stackoverflow.com/a/15895048
        setNeedsUpdateConstraints()
    }
    
    private func loadPosterImageView() {
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(posterImageView)
    }
    
    private func loadRatingRingView() {
        ratingRingView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ratingRingView)
    }
    
    private func loadTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
    }
    
    private func loadDateLabel() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateLabel)
    }
}

// MARK: - Auto Layout Setup

extension MovieListTableViewCell {
    private var views: [String: UIView] {
        let dict: [String: UIView] = ["poster": posterImageView,
                                      "rating": ratingRingView,
                                      "title": titleLabel,
                                      "date": dateLabel]
        return dict
    }
    
    private var allLayoutConstraints: [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        constraints += posterImageViewVConstraints
        constraints += ratingRingViewVConstraints
        constraints += titleLabelVConstraints
        constraints += dateLabelVConstraints
        constraints += posterAndTitleHConstraints
        constraints += posterAndRatingRingAndDateHConstraints
        return constraints
    }
    
    private var posterImageViewVConstraints: [NSLayoutConstraint] {
        let VFLStr = "V:|-\(outerPadding)-[poster(\(posterHeight))]-\(outerPadding)-|"
        return NSLayoutConstraint.constraints(withVisualFormat: VFLStr, options: [], metrics: nil, views: views)
    }
    
    private var ratingRingViewVConstraints: [NSLayoutConstraint] {
        let VFLStr = "V:[rating(\(ratingHeight))]-\(outerPadding)-|"
        return NSLayoutConstraint.constraints(withVisualFormat: VFLStr, options: [], metrics: nil, views: views)
    }
    
    private var titleLabelVConstraints: [NSLayoutConstraint] {
        let VFLStr = "V:|-\(outerPadding)-[title(\(titleHeight))]"
        return NSLayoutConstraint.constraints(withVisualFormat: VFLStr, options: [], metrics: nil, views: views)
    }
    
    private var dateLabelVConstraints: [NSLayoutConstraint] {
        let VFLStr = "V:[date(\(dateHeight))]-\(outerPadding)-|"
        return NSLayoutConstraint.constraints(withVisualFormat: VFLStr, options: [], metrics: nil, views: views)
    }
    
    private var posterAndTitleHConstraints: [NSLayoutConstraint] {
        let VFLStr = "H:|-\(outerPadding)-[poster(\(posterWidth))]-\(innerPadding)-[title]-\(outerPadding)-|"
        return NSLayoutConstraint.constraints(withVisualFormat: VFLStr, options: [], metrics: nil, views: views)
    }
    
    private var posterAndRatingRingAndDateHConstraints: [NSLayoutConstraint] {
        let OP: CGFloat = outerPadding
        let IP: CGFloat = innerPadding
        let VFLStr = "H:|-\(OP)-[poster(\(posterWidth))]-\(IP)-[rating(\(ratingWidth))]-\(IP)-[date]-\(OP)-|"
        return NSLayoutConstraint.constraints(withVisualFormat: VFLStr, options: [], metrics: nil, views: views)
    }
    
    private func setUpAndActivateLayoutConstraints() {
        NSLayoutConstraint.activate(allLayoutConstraints)
    }
}
