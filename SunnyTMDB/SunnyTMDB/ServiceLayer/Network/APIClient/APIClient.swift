//
//  APIClient.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/11/21.
//

import Foundation

class APIClient: APIClientProtocol {
    private static let defaultBearerToken: String = ""
    
    private var bearerToken: String
    var httpManager: HTTPManagerProtocol
    
    private init(bearerToken: String, httpManager: HTTPManagerProtocol) {
        self.httpManager = httpManager
        self.bearerToken = bearerToken
    }
    
    var defaultInstance: APIClientProtocol {
        // TODO: Need to save and retrive bearerToken from Keychain Services to make this production ready.
        let instance = APIClient(bearerToken: Self.defaultBearerToken, httpManager: AlamofireHTTPManager())
        return instance
    }
}
