//
//  VideoDTO.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 10/17/21.
//

import Foundation

struct VideoDTO: Codable {
    let typeOfVideo: String
    let site: String
    let uriStr: String
    let isOfficial: Bool
    
    enum CodingKeys: String, CodingKey {
        case typeOfVideo = "type"
        case site
        case uriStr  = "key"
        case isOfficial = "official"
    }
}
