//
//  MovieSearchDataService.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/12/21.
//

import Foundation

struct MovieSearchGetRequestParam {
    let query: String
    let page: Int
    
    var queryStrParams: [String: Any] {
        let params: [String: Any] = ["query": query, "page": page]
        return params
    }
}

class MovieSearchDataService {
    private static let defaultURIStr: String = "/search/movie"
    
    let apiClient: APIClientProtocol
    let uriStr: String = defaultURIStr
    
    init(apiClient: APIClientProtocol = TMDBAPIClient.defaultInstance) {
        self.apiClient = apiClient
    }
}

// MARK: - MovieSearchDataServiceProtocol Conformation

extension MovieSearchDataService: MovieSearchDataServiceProtocol {
    func sendGetRequest(param: MovieSearchGetRequestParam,
                        successHandler: @escaping (GetSearchMovieResponseDTO) -> Void,
                        failureHandler: ((HTTPStatusCode?) -> Void)?)
    {
        let jsonHandler = JSONCoderUtility.getJSONHandler(successHandler: successHandler,
                                                          failureHandler: failureHandler)
        let urlStr = apiClient.getURLStr(uriStr: uriStr)
        let queryStrParams = apiClient.getQueryStrParamSignedByAPIKey(queryStrParams: param.queryStrParams)
        apiClient.httpManager.sendHTTPGETRequest(urlStr: urlStr,
                                                 headers: nil,
                                                 queryStringParams: queryStrParams,
                                                 jsonHandler: jsonHandler,
                                                 failureHandler: failureHandler)
        
    }
}
