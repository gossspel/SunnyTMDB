//
//  MoviesSearchDataService.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/12/21.
//

import Foundation

struct MoviesSearchGetRequestParam {
    let query: String
}

class MoviesSearchDataService {
    private static let defaultURIStr: String = "/search/movie"
    
    var apiClient: APIClientProtocol
    var uriStr: String
    
    init(apiClient: APIClientProtocol = APIClient.defaultInstance, uriStr: String = defaultURIStr) {
        self.apiClient = apiClient
        self.uriStr = uriStr
    }
    
    func sendGetRequest(param: MoviesSearchGetRequestParam,
                        successHandler: @escaping (MoviesSearchResultDTO) -> Void,
                        failureHandler: ((HTTPStatusCode?) -> Void)?)
    {
        let jsonHandler = JSONCoderUtility.getJSONHandler(successHandler: successHandler,
                                                          failureHandler: failureHandler)
        let urlStr = apiClient.getURLStr(uriStr: uriStr)
        // TODO: finish the headers and queryStrParams
        apiClient.httpManager.sendHTTPGETRequest(urlStr: urlStr,
                                                 headers: nil,
                                                 queryStringParams: nil,
                                                 jsonHandler: jsonHandler,
                                                 failureHandler: failureHandler)
        
    }
}
