//
//  GetMovieVideosResponseDTO.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 10/17/21.
//

import Foundation

struct GetMovieVideosResponseDTO: Codable {
    let videos: [VideoDTO?]
    
    enum CodingKeys: String, CodingKey {
        case videos = "result"
    }
}
