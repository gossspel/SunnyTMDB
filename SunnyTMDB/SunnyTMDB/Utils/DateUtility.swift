//
//  DateUtility.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/11/21.
//

import Foundation

class DateUtility {
    static var currentDate: Date {
        return Date()
    }
    
    static var currentDateStrInDebugFormat: String {
        let dateStr: String = currentDate.description(with: .current)
        return dateStr
    }
}
