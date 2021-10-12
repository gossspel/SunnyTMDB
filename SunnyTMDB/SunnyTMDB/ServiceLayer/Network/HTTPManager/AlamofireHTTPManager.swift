//
//  AlamofireHTTPManager.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/11/21.
//

import Foundation
import Alamofire

class AlamofireHTTPManager {
    private static func getHTTPHeaders(headers: [String : String]?) -> HTTPHeaders? {
        guard let sureHeaders = headers else {
            return nil
        }
        
        return HTTPHeaders(sureHeaders)
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
        
        let dataResponseHandler: (AFDataResponse<String>) -> Void = { (data: AFDataResponse<String>) in
            Self.handleDataResponse(data: data,
                                    method: method,
                                    jsonHandler: jsonHandler,
                                    failureHandler: failureHandler)
        }
        
        
        dataRequest.responseString(queue: DispatchQueue.global(qos: .userInteractive),
                                   completionHandler: dataResponseHandler)
    }
    
    private static func handleDataResponse(data: AFDataResponse<String>,
                                           method: HTTPMethod,
                                           jsonHandler: @escaping (String) -> Void,
                                           failureHandler: ((HTTPStatusCode?) -> Void)?)
    {
        guard let requestURL = ConsoleUtility.validate(optional: data.request?.url) else {
            return
        }
        
        let urlStr: String = requestURL.absoluteString
        
        switch data.result {
        case .success:
            if let statusCode = ConsoleUtility.validate(optional: data.response?.statusCode),
               let jsonStr = ConsoleUtility.validate(optional: data.value),
               200...299 ~= statusCode
            {
                let successMessage = "HTTP \(method.rawValue) request of \(urlStr) succeeded."
                ConsoleUtility.printConsoleMessage(messageType: .success, message: successMessage)
                jsonHandler(jsonStr)
            } else {
                let statusCodeIntValue: Int = data.response?.statusCode ?? -1
                let statusCodeStrValue: String = (statusCodeIntValue != -1) ? String(statusCodeIntValue) : "nil"
                let jsonStrValue: String = data.value ?? "nil"
                var errorMessage = "HTTP \(method.rawValue) request of \(urlStr) failed with "
                errorMessage += "statusCode: \(statusCodeStrValue), "
                errorMessage += "JSONStr: \(jsonStrValue)."
                ConsoleUtility.printConsoleMessage(messageType: .error, message: errorMessage)
                failureHandler?(data.response?.statusCode)
            }
            
        case let .failure(error):
            var errorMessage = "HTTP \(method.rawValue) request of \(urlStr) failed without status code, error: "
            errorMessage += error.localizedDescription
            ConsoleUtility.printConsoleMessage(messageType: .error, message: errorMessage)
            failureHandler?(nil)
        }
        
    }
}

// MARK: - HTTPManagerProtocol Conformation

extension AlamofireHTTPManager: HTTPManagerProtocol {
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
}
