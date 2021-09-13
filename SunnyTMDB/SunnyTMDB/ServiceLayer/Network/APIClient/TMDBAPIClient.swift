//
//  TMDBAPIClient.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/11/21.
//

import Foundation

final class TMDBAPIClient {
    private static let defaultBearerToken: String = ""
    private static let defaultBaseURLStr: String = "https://api.themoviedb.org/3"
    
    private var baseURLStr: String
    private var bearerToken: String
    var httpManager: HTTPManagerProtocol
    
    private init(baseURLStr: String, bearerToken: String, httpManager: HTTPManagerProtocol) {
        self.baseURLStr = baseURLStr
        self.bearerToken = bearerToken
        self.httpManager = httpManager
    }
    
    static var defaultInstance: APIClientProtocol {
        // TODO: Need to save and retrive bearerToken from Keychain Services to make this production ready.
        let instance = TMDBAPIClient(baseURLStr: defaultBaseURLStr,
                                     bearerToken: defaultBearerToken,
                                     httpManager: AlamofireHTTPManager())
        return instance
    }
}

extension TMDBAPIClient: APIClientProtocol {
    func getAuthorizedHeaders(headers: [String : String]?) -> [String : String] {
        var authorizedHeaders: [String : String] = headers ?? [:]
        authorizedHeaders["Authorization"] = "Bearer \(bearerToken)"
        return authorizedHeaders
    }
    
    func getURLStr(uriStr: String) -> String {
        let urlStr = "\(baseURLStr)/\(uriStr)"
        return urlStr
    }
}
