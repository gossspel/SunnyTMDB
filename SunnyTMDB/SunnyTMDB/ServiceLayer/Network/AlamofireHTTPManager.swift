//
//  AlamofireHTTPManager.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/11/21.
//

import Foundation
import Alamofire

class AlamofireHTTPManager: HTTPManagerProtocol {
    static func getHTTPHeaders(headers: [String : String]?) -> HTTPHeaders? {
        guard let sureHeaders = headers else {
            return nil
        }
        
        return HTTPHeaders(sureHeaders)
    }
    
    func sendHTTPGETRequest(urlStr: String,
                            headers: [String : String]?,
                            queryStringParams: [String : Any]?,
                            jsonHandler: @escaping (String) -> Void,
                            failureHandler: ((HTTPStatusCode?) -> Void)?)
    {
        self.sendHTTPRequest(method: .get,
                             urlStr: urlStr,
                             headers: headers,
                             params: queryStringParams,
                             paramEncoding: URLEncoding.queryString,
                             jsonHandler: jsonHandler,
                             failureHandler: failureHandler)
    }
    
    private func sendHTTPRequest(method: HTTPMethod,
                                 urlStr: String,
                                 headers: [String : String]?,
                                 params: [String : Any]?,
                                 paramEncoding: ParameterEncoding,
                                 jsonHandler: @escaping (String) -> Void,
                                 failureHandler: ((HTTPStatusCode?) -> Void)?)
    {
        let httpHeaders: HTTPHeaders? = Self.getHTTPHeaders(headers: headers)
        let dataRequest = AF.request(urlStr,
                                     method: method,
                                     parameters: params,
                                     encoding: paramEncoding,
                                     headers: httpHeaders)
        
        let dataResponseHandler: (AFDataResponse<String>) -> Void = { [weak self] (data: AFDataResponse<String>) in
            // TODO: finish this
        }
        
        dataRequest.responseString(queue: DispatchQueue.global(qos: .userInteractive),
                                   completionHandler: dataResponseHandler)
    }
}
