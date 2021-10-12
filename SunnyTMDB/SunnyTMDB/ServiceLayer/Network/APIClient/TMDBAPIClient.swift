//
//  TMDBAPIClient.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/11/21.
//

import Foundation

final class TMDBAPIClient {
    private static let defaultBaseURLStr: String = "https://api.themoviedb.org/3"
    private static let defaultAPIKey: String = "181af7fcab50e40fabe2d10cc8b90e37"
    
    private var apiKey: String
    private var baseURLStr: String
    var httpManager: HTTPManagerProtocol
    
    private init(apiKey: String, baseURLStr: String, httpManager: HTTPManagerProtocol) {
        self.apiKey = apiKey
        self.baseURLStr = baseURLStr
        self.httpManager = httpManager
    }
    
    static var defaultInstance: APIClientProtocol {
        let instance = TMDBAPIClient(apiKey: defaultAPIKey,
                                     baseURLStr: defaultBaseURLStr,
                                     httpManager: AlamofireHTTPManager())
        return instance
    }
}

extension TMDBAPIClient: APIClientProtocol {
    func getQueryStrParamSignedByAPIKey(queryStrParams: [String : Any]) -> [String : Any] {
        var updatedQueryStrParams = queryStrParams
        updatedQueryStrParams["api_key"] = apiKey
        return updatedQueryStrParams
    }
    
    func getURLStr(uriStr: String) -> String {
        let urlStr = "\(baseURLStr)\(uriStr)"
        return urlStr
    }
}
