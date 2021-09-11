//
//  HTTPManager.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/10/21.
//

import Foundation

typealias HTTPStatusCode = Int

protocol HTTPManagerProtocol {
    func sendHTTPGETRequest(URLStr: String,
                            headers: [String: String]?,
                            queryStringParams: [String: Any]?,
                            JSONHandler: @escaping (String) -> Void,
                            failureHandler: ((HTTPStatusCode?) -> Void)?) -> Void
}

extension HTTPManagerProtocol {
    func sendHTTPGETRequest(URLStr: String,
                            headers: [String: String]? = nil,
                            queryStringParams: [String: Any]? = nil,
                            JSONHandler: @escaping (String) -> Void,
                            failureHandler: ((HTTPStatusCode?) -> Void)?) -> Void
    {
        sendHTTPGETRequest(URLStr: URLStr,
                           headers: headers,
                           queryStringParams: queryStringParams,
                           JSONHandler: JSONHandler,
                           failureHandler: failureHandler)
    }
}
