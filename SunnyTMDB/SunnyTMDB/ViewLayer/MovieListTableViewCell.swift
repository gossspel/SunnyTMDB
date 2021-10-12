//
//  MovieListTableViewCell.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/13/21.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {
    let posterImageView: UIImageView = UIImageView()
    let ratingRingView: RingPercentView = RingPercentView()
    let titleLabel: UILabel = UILabel()
    let dateLabel: UILabel = UILabel()
    let overviewLabel: UILabel = UILabel()
    
    private var outerPadding: CGFloat = 16
    private var innerPadding: CGFloat = 8
    private var posterHeight: CGFloat = 150
    
    private var posterWidth: CGFloat {
        return posterHeight * 2 / 3
    }
    
    private var titleHeight: CGFloat {
        return posterHeight / 3
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
        loadOverviewLabel()
        
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
    
    private func loadOverviewLabel() {
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.numberOfLines = 0
        contentView.addSubview(overviewLabel)
    }
}

// MARK: - Auto Layout Setup

extension MovieListTableViewCell {
    private var views: [String: UIView] {
        let dict: [String: UIView] = ["poster": posterImageView,
                                      "rating": ratingRingView,
                                      "title": titleLabel,
                                      "date": dateLabel,
                                      "overview": overviewLabel]
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
        constraints += overviewLabelVConstraints
        constraints += overviewLabelHConstraints
        return constraints
    }
    
    private var posterImageViewVConstraints: [NSLayoutConstraint] {
        let VFLStr = "V:|-\(outerPadding)-[poster(\(posterHeight))]"
        return NSLayoutConstraint.constraints(withVisualFormat: VFLStr, options: [], metrics: nil, views: views)
    }
    
    private var overviewLabelVConstraints: [NSLayoutConstraint] {
        let VFLStr = "V:[poster]-\(innerPadding)-[overview]-\(outerPadding)-|"
        return NSLayoutConstraint.constraints(withVisualFormat: VFLStr, options: [], metrics: nil, views: views)
    }
    
    private var overviewLabelHConstraints: [NSLayoutConstraint] {
        let VFLStr = "H:|-\(outerPadding)-[overview]-\(outerPadding)-|"
        return NSLayoutConstraint.constraints(withVisualFormat: VFLStr, options: [], metrics: nil, views: views)
    }
    
    private var ratingRingViewVConstraints: [NSLayoutConstraint] {
        let VFLStr = "V:[title]-\(innerPadding)-[rating(\(ratingHeight))]"
        return NSLayoutConstraint.constraints(withVisualFormat: VFLStr, options: [], metrics: nil, views: views)
    }
    
    private var titleLabelVConstraints: [NSLayoutConstraint] {
        let VFLStr = "V:|-\(outerPadding)-[title(\(titleHeight))]"
        return NSLayoutConstraint.constraints(withVisualFormat: VFLStr, options: [], metrics: nil, views: views)
    }
    
    private var dateLabelVConstraints: [NSLayoutConstraint] {
        let VFLStr = "V:[title]-\(innerPadding)-[date(\(dateHeight))]"
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
