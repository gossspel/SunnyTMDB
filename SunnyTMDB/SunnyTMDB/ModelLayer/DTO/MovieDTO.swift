//
//  MovieDTO.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/12/21.
//

import Foundation

struct MovieDTO: Codable {
    let title: String?
    let overview: String?
    let releaseDateStr: String?
    let posterURI: String?
    let rating: Double?
    let genreIDs: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case releaseDateStr = "release_date"
        case posterURI = "poster_path"
        case rating = "vote_average"
        case genreIDs = "genre_ids"
    }
}

// MARK: - computed properties 

extension MovieDTO {
    var ratingPercent: Int? {
        guard let sureRating = rating else {
            return nil
        }
        
        return Int(sureRating * 10)
    }
}
