//
//  MovieSearchResultDTO.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/12/21.
//

import Foundation

struct MovieSearchResultDTO: Codable {
    let currentPage: Int
    let totalPagesCount: Int
    let movies: [MovieDTO]
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "page"
        case totalPagesCount = "total_pages"
        case movies = "results"
    }
}
