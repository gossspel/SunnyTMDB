//
//  MovieDTO.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/12/21.
//

import Foundation

struct MovieDTO: Codable {
    let title: String
    let overview: String
    let posterURI: String?
    let rating: Decimal
    let genreIDs: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case posterURI = "poster_path"
        case rating = "vote_average"
        case genreIDs = "genre_ids"
    }
}
