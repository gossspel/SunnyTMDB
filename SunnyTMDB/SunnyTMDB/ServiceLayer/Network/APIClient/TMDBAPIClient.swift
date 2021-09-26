//
//  TMDBAPIClient.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/11/21.
//

import Foundation

final class TMDBAPIClient {
    private static let defaultBaseURLStr: String = "https://api.themoviedb.org/3"
    
    private var baseURLStr: String
    var httpManager: HTTPManagerProtocol
    
    private init(baseURLStr: String, httpManager: HTTPManagerProtocol) {
        self.baseURLStr = baseURLStr
        self.httpManager = httpManager
    }
    
    static var defaultInstance: APIClientProtocol {
        let instance = TMDBAPIClient(baseURLStr: defaultBaseURLStr,
                                     httpManager: AlamofireHTTPManager())
        return instance
    }
}

extension TMDBAPIClient: APIClientProtocol {
    func getURLStr(uriStr: String) -> String {
        let urlStr = "\(baseURLStr)/\(uriStr)"
        return urlStr
    }
}
