//
//  APIClient.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/11/21.
//

import Foundation

class APIClient {
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
    
    var defaultInstance: APIClientProtocol {
        // TODO: Need to save and retrive bearerToken from Keychain Services to make this production ready.
        let instance = APIClient(baseURLStr: Self.defaultBaseURLStr,
                                 bearerToken: Self.defaultBearerToken,
                                 httpManager: AlamofireHTTPManager())
        return instance
    }
}

extension APIClient: APIClientProtocol {
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
