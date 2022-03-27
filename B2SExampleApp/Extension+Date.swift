//  B2S
//
//  Created by Egor Sakhabaev on 11.04.2018.
//  Copyright © 2018 Egor Sakhabaev. All rights reserved.
//
import UIKit

public extension Date {
    
    func stringFromDate(format: String? = "dd.MM.yyyy") -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format

        let resultString = dateFormatter.string(from: self)
        
        return resultString
    }

    func dateFromDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        
        let resultString = dateFormatter.string(from: self)
        
        return resultString
    }
    
    func monthFromDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        dateFormatter.locale = Locale(identifier: "ru")
        
        let resultString = dateFormatter.string(from: self)
        
        return resultString
    }
    
    func startOfMonth() -> Date {
        let a = Calendar.current.startOfDay(for: self)
        let b = Calendar.current.dateComponents([.year, .month], from: a)
        return Calendar.current.date(from: b)!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    var dayAfterTomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 2, to: self)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var day: Int {
        return Calendar.current.component(.day,  from: self)
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var year: Int {
        return Calendar.current.component(.year,  from: self)
    }

    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
    
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}

public extension String {
    
    func dateFromString(format: String? = "dd.MM.yyyy") -> Date? {
        guard format != nil else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        let resultDate = dateFormatter.date(from: self)
        return resultDate
    }
    
    static func estimageTextSize(text: String?, size: CGSize = CGSize(width: 200, height: 1000), font: UIFont = UIFont.systemFont(ofSize: 14)) -> CGRect? {
        
        guard let text = text else { return nil }
        
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: options, attributes:
            [.font: font], context: nil)
        
        return estimatedFrame
    }
}

public extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the amount of seconds from another date
    func miliseconds(from date: Date) -> Int {
        return (Calendar.current.dateComponents([.nanosecond], from: date, to: self).nanosecond ?? 0) / 1000000
    }
    /// Returns the amount of nanoseconds from another date
    func nanoseconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.nanosecond], from: date, to: self).nanosecond ?? 0
    }
}

public extension Date {
    func dayOfWeek() -> Int? {
        let calendar = Calendar(identifier: .gregorian)
        var weekday = calendar.dateComponents([.weekday], from: self).weekday ?? 0
//        weekday -= 2 - calendar.firstWeekday
        weekday -= 1
        if weekday == 0 {
            weekday = 7
        }
        return weekday
    }
    
    func dayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)
        let weekday = calendar.dateComponents([.weekday], from: self).weekday ?? 0
        return dateFormatter.weekdaySymbols[weekday-1]
    }
    
    func formatRelativeString(dateStyleForAfterTodayDate: DateFormatter.Style, timeStyle: DateFormatter.Style = .none) -> String {
        let dateFormatter = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.timeStyle = timeStyle

        if calendar.isDateInToday(self) {
            dateFormatter.dateStyle = .short
        }else if calendar.isDateInYesterday(self){
            dateFormatter.dateStyle = .medium
        } else if calendar.isDateInTomorrow(self) {
            dateFormatter.dateStyle = .short
        } /*else if calendar.compare(Date(), to: self, toGranularity: .weekOfYear) == .orderedSame {
            let weekday = calendar.dateComponents([.weekday], from: self).weekday ?? 0
            return dateFormatter.weekdaySymbols[weekday-1]
        } */else {
            switch dateStyleForAfterTodayDate {
            case .medium:
                let format = timeStyle == .none ? "dd MMMM" : "dd MMMM HH:mm"
                return stringFromDate(format: format)
            default:
                dateFormatter.dateStyle = dateStyleForAfterTodayDate
            }
            dateFormatter.dateStyle = dateStyleForAfterTodayDate
        }

        return dateFormatter.string(from: self).lowercased()
    }

}
