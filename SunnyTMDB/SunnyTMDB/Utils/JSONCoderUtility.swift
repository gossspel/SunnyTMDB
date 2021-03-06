//
//  JSONCoderUtility.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/12/21.
//

import Foundation

class JSONCoderUtility {
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()
    
    /// Method to decode JSON String to a generic codable object/array.
    /// - Parameter jsonStr: the JSON string
    /// - Returns: The codable object/array or nil if decoding failed.
    static func decode<T: Codable>(jsonStr: String?) -> T? {
        guard let sureJSONStr = jsonStr, let data = sureJSONStr.data(using: .utf8, allowLossyConversion: false) else {
            return nil
        }
        
        do {
            let decodedObject: T = try decoder.decode(T.self, from: data)
            return decodedObject
        } catch {
            ConsoleUtility.printConsoleMessage(messageType: .error, message: error.localizedDescription)
            return nil
        }
    }
    
    /// Method to encode generic codable pointer to JSON string.
    /// - Parameter codablePointer: Any object instance that conforms to Codable.
    /// - Returns: The JSON string or nil if encoding failed.
    static func encode<T: Codable>(codablePointer: T?) -> String? {
        guard let data = try? encoder.encode(codablePointer), let jsonStr = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return jsonStr
    }
    
    static func getJSONHandler<T: Codable>(successHandler: @escaping (T) -> Void,
                                           failureHandler: ((HTTPStatusCode?) -> Void)?,
                                           filePathName: String = #file,
                                           methodName: String = #function,
                                           lineNumber: Int = #line) -> ((String) -> Void)
    {
        let jsonHandler: (String) -> Void = { (jsonStr: String) in
            guard let dto: T = decode(jsonStr: jsonStr) else {
                let errorMessage = "fail to decode from JSON string: \(jsonStr)"
                ConsoleUtility.printConsoleMessage(messageType: .error,
                                                   message: errorMessage,
                                                   filePathName: filePathName,
                                                   methodName: methodName,
                                                   lineNumber: lineNumber)
                failureHandler?(200)
                return
            }
            
            successHandler(dto)
        }
        
        return jsonHandler
    }
}
