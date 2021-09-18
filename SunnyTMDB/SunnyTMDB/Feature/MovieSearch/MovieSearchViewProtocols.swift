//
//  MovieSearchViewProtocols.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/16/21.
//

import Foundation

protocol MovieSearchViewProtocol: AnyObject {
    func refreshTable()
}

protocol MovieListTableViewCellProtocol: AnyObject {
    var titleLabel: LabelProtocol { get }
    var dateLabel: LabelProtocol { get }
    var posterImageView: ImageViewProtocol { get }
    var ratingRingView: RingPercentViewProtocol { get }
}
