//
//  MovieVideoDataService.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 10/15/21.
//

import Foundation

class MovieVideoDataService {
    private static let defaultURIFormatStr: String = "/movie/%d/videos"
    
    let apiClient: APIClientProtocol
    let uriFormatStr: String = defaultURIFormatStr
    
    init(apiClient: APIClientProtocol = TMDBAPIClient.defaultInstance) {
        self.apiClient = apiClient
    }
    
    func getURIStr(movieID: Int) -> String {
        let uriStr = String(format: uriFormatStr, movieID)
        return uriStr
    }
}


