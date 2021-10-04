//
//  MovieSearchViewProtocols.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/16/21.
//

import Foundation

protocol MovieSearchViewProtocol: AnyObject {
    var emptyTableLabelObject: LabelProtocol { get }
    func refreshTable()
    func updateVisibilityOfTableBackgroundView(setIsHidden: Bool)
    func doBatchOperationsInTable(indexPathsToDelete: [IndexPath], indexPathsToInsert: [IndexPath])
}

protocol MovieListTableViewCellProtocol: AnyObject {
    var titleLabelObject: LabelProtocol { get }
    var dateLabelObject: LabelProtocol { get }
    var posterImageViewObject: ImageViewProtocol { get }
    var ratingRingViewObject: RingPercentViewProtocol { get }
    
    func updateOuterPadding(padding: Float)
    func updateInnerPadding(padding: Float)
    func updatePosterHeight(height: Float)
}

protocol LoadingTableViewCellProtocol {
    func updateOverallHeight(height: Float)
    func startSpinning()
}
