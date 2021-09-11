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
        // TODO: finish this
    }
}
