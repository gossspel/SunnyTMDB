//
//  ConsoleUtility.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/11/21.
//

import Foundation

enum ConsoleMessageType: String, Codable {
    case error
    case success
    case warning
    
    var colorStr: String {
        // NOTE: the color emoji is from the two links below:
        // LINK: https://github.com/SwiftyBeaver/SwiftyBeaver/blob/master/Sources/ConsoleDestination.swift
        // LINK: https://stackoverflow.com/a/20377402
        switch self {
        case .error:
            return "❤️❤️❤️❤️❤️"
        case.success:
            return "💚💚💚💚💚"
        case .warning:
            return "💛💛💛💛💛"
        }
    }
}

class ConsoleUtility {
    static func printConsoleMessage(messageType: ConsoleMessageType,
                                    message: String,
                                    filePathName: String = #file,
                                    methodName: String = #function,
                                    lineNumber: Int = #line)
    {
        let dateTimeStr: String = DateUtility.currentDateStrInDebugFormat
        let colorStr: String = messageType.colorStr
        let typeStr: String = messageType.rawValue.capitalized
        let fileName: String = getFileName(filePathName: filePathName)
        let completeMessageStrA: String = "\(colorStr) \(dateTimeStr): \(typeStr) from "
        let completeMessageStrB: String = "\(fileName)'s \(methodName) on line #\(lineNumber) - \(message)\n"
        let completeMessageStr: String = "\(completeMessageStrA)\(completeMessageStrB)"
        print(completeMessageStr)
    }
    
    /// Method to validate condtion and print error message if there is any
    ///
    /// - Parameters:
    ///   - condition: Bool - the condition you want to check for
    ///   - errorMessage: String? - the error message str, if nil is passed, default error message will be used
    ///   - filePathName: String - the name of the method's file that calls this method
    ///   - methodName: String - the name of the method that calls this method
    ///   - lineNumber: Int - the line number that that calls this method
    /// - Returns: Bool - true if the condition is valid else false
    static func validate(condition: Bool,
                         errorMessage: String? = nil,
                         filePathName: String = #file,
                         methodName: String = #function,
                         lineNumber: Int = #line) -> Bool
    {
        let defaultErrorMessage: String = "False condition detected!"
        let sureErrorMessage: String = errorMessage ?? defaultErrorMessage
        
        guard condition else {
            printConsoleMessage(messageType: .error,
                                message: sureErrorMessage,
                                filePathName: filePathName,
                                methodName: methodName,
                                lineNumber: lineNumber)
            return false
        }
        
        return true
    }
    
    ///  Method to validate optional and print error message if there is any
    ///
    /// - Parameters:
    ///   - optional: T? - the generic optional type that you want to do nil check for
    ///   - errorMessage: String? - the error message str, if nil is passed, default error message will be used
    ///   - filePathName: String - the name of the method's file that calls this method
    ///   - methodName: String - the name of the method that calls this method
    ///   - lineNumber: Int - the line number that that calls this method
    /// - Returns: T? - T if the optional binding succceed else nil
    static func validate<T>(optional: T?,
                            errorMessage: String? = nil,
                            filePathName: String = #file,
                            methodName: String = #function,
                            lineNumber: Int = #line) -> T?
    {
        let defaultErrorMessage: String = "Nil optional detected!"
        let sureErrorMessage: String = errorMessage ?? defaultErrorMessage
        
        guard let sureOptional = optional else {
            printConsoleMessage(messageType: .error,
                                message: sureErrorMessage,
                                filePathName: filePathName,
                                methodName: methodName,
                                lineNumber: lineNumber)
            return nil
        }
        
        return sureOptional
    }
    
    static func getFileName(filePathName: String) -> String {
        let fileName: String = (filePathName as NSString).lastPathComponent
        return fileName
    }
}
