//
//  AlamofireHTTPManager.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/11/21.
//

import Foundation
import Alamofire

class AlamofireHTTPManager: HTTPManagerProtocol {
    func sendHTTPGETRequest(URLStr: String, headers: [String : String]?,
                            queryStringParams: [String : Any]?,
                            JSONHandler: @escaping (String) -> Void,
                            failureHandler: ((HTTPStatusCode?) -> Void)?)
    {
        // TODO: finish this
    }
}
