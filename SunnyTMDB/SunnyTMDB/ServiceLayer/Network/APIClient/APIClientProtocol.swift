//
//  APIClient.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/10/21.
//

import Foundation

protocol APIClientProtocol {
    var httpManager: HTTPManagerProtocol { get }
}
