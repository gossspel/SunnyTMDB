//
//  MovieSearchDataStructures.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 10/11/21.
//

import Foundation

enum MovieSearchTableCellType: String, CaseIterable {
    case movieCell
    case loadingCell
    
    var cellReuseID: String {
        switch self {
        case .movieCell:
            return "MovieListTableViewCell"
        case .loadingCell:
            return "LoadingTableViewCell"
        }
    }
}

enum EmptyMovieSearchTableReason: String {
    case noSearchQuery
    case noMoviesFromSearch
    
    var displayStr: String {
        switch self {
        case .noSearchQuery:
            return "Search for a movie..."
        case .noMoviesFromSearch:
            return "No movies found! Try searching again..."
        }
    }
}

struct MovieSearchTableCellData {
    let cellType: MovieSearchTableCellType
    let movieDTO: MovieDTO?
}

struct MovieCellViewData {
    let imageURLStr: String?
    let titleLabelStr: String?
    let overviewLabelStr: String?
    let dateLabelStr: String?
    let percentLabelStr: String?
    let ringFillPercent: Int
    let ringFillHexColorStr: String?
}
