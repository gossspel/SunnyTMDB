//
//  DataServiceProtocols.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/23/21.
//

import Foundation

protocol MovieSearchDataServiceProtocol: AnyObject {
    func sendGetRequest(param: MovieSearchGetRequestParam,
                        successHandler: @escaping (MovieSearchResultDTO) -> Void,
                        failureHandler: ((HTTPStatusCode?) -> Void)?)
}
