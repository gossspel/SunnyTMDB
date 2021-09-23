//
//  MovieSearchDataService.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/12/21.
//

import Foundation

struct MovieSearchGetRequestParam {
    let query: String
}

class MovieSearchDataService {
    private static let defaultURIStr: String = "/search/movie"
    
    var apiClient: APIClientProtocol
    var uriStr: String
    
    init(apiClient: APIClientProtocol = TMDBAPIClient.defaultInstance, uriStr: String = defaultURIStr) {
        self.apiClient = apiClient
        self.uriStr = uriStr
    }
    
    func sendGetRequest(param: MovieSearchGetRequestParam,
                        successHandler: @escaping (MovieSearchResultDTO) -> Void,
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
