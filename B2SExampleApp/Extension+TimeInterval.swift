//
//  Extension+TimeInterval.swift
//  B2S
//
//  Created by Egor Sakhabaev on 01.10.2021.
//

import Foundation

public extension TimeInterval {
    fileprivate var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        return dateFormatter
    }

    func stringWithFormatType(_ dateFormat: DateFormatType = .fullWithoutSeconds) -> String? {
        let formatter = dateFormatter
        formatter.dateFormat = dateFormat.rawValue
        return formatter.string(from: Date(timeIntervalSince1970: self))
    }
    
    func stringWithFormatString(_ dateFormat: String = "dd.MM.yyyy HH:mm", useTrueFormatter: Bool = false) -> String? {
        let formatter = dateFormatter
        formatter.dateFormat = dateFormat
        return formatter.string(from: Date(timeIntervalSince1970: self))
    }
    
    func formatedTime(allowedUnits: NSCalendar.Unit = [.minute, .second]) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional // Use the appropriate positioning for the current locale
        formatter.allowedUnits = allowedUnits // Units to display in the formatted string
        formatter.zeroFormattingBehavior = [.pad] // Pad with zeroes where appropriate for the locale
        return formatter.string(from: self)?.replacingOccurrences(of: "0d ", with: "")
    }
    
    var day: Int {
        Int((self / 86400).truncatingRemainder(dividingBy: 86400))
    }
    
    var hour: Int {
        Int((self / 3600).truncatingRemainder(dividingBy: 3600))
    }
    
    var minute: Int {
        Int((self / 60).truncatingRemainder(dividingBy: 60))
    }
    
    var second: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
    
    var millisecond: Int {
        Int((self * 1000).truncatingRemainder(dividingBy: 1000))
    }
}

public enum DateFormatType: String {
    case full = "dd.MM.yyyy HH:mm:ss"
    case fullTwoDigitsYear = "dd.MM.yy HH:mm"
    case dateTwoDigitsYear = "dd.MM.yy"
    case fullMonthNameWithoutSeconds = "dd MMM YY HH:mm"
    case fullWithoutSeconds = "dd.MM.yyyy HH:mm"
    case onlyTime = "HH:mm:ss"
    case onlyTimeWithoutSeconds = "HH:mm"
    case onlyDate = "dd.MM.yyyy"
    case dayMonth = "d MMMM"
}
