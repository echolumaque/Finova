//
//  Date+Extension.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/22/25.
//

import Dispatch
import Foundation

extension Date {
    private nonisolated(unsafe) static var formatters: [String: DateFormatter] = [:]
    private static let formattersQueue = DispatchQueue(label: "dev.mobinova.Finova.dateFormatters", attributes: .concurrent)

    init(calendar: Calendar? = nil,
         timeZone: TimeZone? = nil,
         era: Int? = nil,
         year: Int? = nil,
         month: Int? = nil,
         day: Int? = nil,
         hour: Int? = nil,
         minute: Int? = nil,
         second: Int? = nil,
         nanosecond: Int? = nil,
         weekday: Int? = nil,
         weekdayOrdinal: Int? = nil,
         quarter: Int? = nil,
         weekOfMonth: Int? = nil,
         weekOfYear: Int? = nil,
         yearForWeekOfYear: Int? = nil)
    {
        let components = DateComponents(calendar: calendar,
                                        timeZone: timeZone,
                                        era: era,
                                        year: year,
                                        month: month,
                                        day: day,
                                        hour: hour,
                                        minute: minute,
                                        second: second,
                                        nanosecond: nanosecond,
                                        weekday: weekday,
                                        weekdayOrdinal: weekdayOrdinal,
                                        quarter: quarter,
                                        weekOfMonth: weekOfMonth,
                                        weekOfYear: weekOfYear,
                                        yearForWeekOfYear: yearForWeekOfYear)

        let newCalendar = calendar ?? Calendar.gregorian
        let date = newCalendar.date(from: components)
        self.init(timeIntervalSinceReferenceDate: date?.timeIntervalSinceReferenceDate ?? Date.now.timeIntervalSinceReferenceDate)
    }

    var asFullDate: String {
        Date.fullDateFormatter.string(from: self)
    }

    var asShortMonthDayTime: String {
        let dayComponent = formatAsMonthDay()
        let timeComponent = Date.getFormatter(dateFormat: "HH").string(from: self)

        return "\(dayComponent) at \(timeComponent)"
    }

    var day: Int {
        Calendar.gregorian.component(.day, from: self)
    }

    var endOfDate: Date {
        Calendar.gregorian.date(bySettingHour: 23, minute: 59, second: 59, of: self) ?? .now
    }

    var endOfMonth: Date {
        let calendar = Calendar.gregorian
        let date = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) ?? .now
        let endOfMonth = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date) ?? .now

        return endOfMonth
    }

    var era: Int {
        Calendar.gregorian.component(.era, from: self)
    }

    var formattedAsGmt: String {
        var formatter = Date.FormatStyle.dateTime
        formatter.timeZone = TimeZone(secondsFromGMT: 28800)!
        let formattedDate = formatted(formatter)

        return formattedDate
    }

    static var fullDateFormatter: DateFormatter {
        if let existingFormatter = formattersQueue.sync(execute: { formatters["fullDate"] }) {
            return existingFormatter
        }

        // If no formatter exists, create one
        let newFormatter = DateFormatter()
        newFormatter.dateStyle = .full
        formattersQueue.async(flags: .barrier) { formatters["fullDate"] = newFormatter }

        return newFormatter
    }

    var getDifferenceBetweenNowString: String {
        let daysDifference = Calendar.gregorian.dateComponents([.year, .month, .day], from: Date.now.stripTime(), to: stripTime())
        guard let year = daysDifference.year,
              let month = daysDifference.month,
              let day = daysDifference.day else { return "Unknown" }

        return "\(year == 0 ? "" : "\(year)y") \(month == 0 ? "" : "\(month)m") \(day == 0 ? "" : "\(day)d")"
    }

    var hour: Int {
        Calendar.gregorian.component(.hour, from: self)
    }

    var isDateInCurrentWeek: Bool {
        let calendar = Calendar.gregorian
        // Get the current week of the year and year
        let currentWeek = calendar.component(.weekOfYear, from: .now)
        let currentYear = calendar.component(.yearForWeekOfYear, from: .now)

        // Get the week of the year and year for the given date
        let dateWeek = calendar.component(.weekOfYear, from: self)
        let dateYear = calendar.component(.yearForWeekOfYear, from: self)

        // Check if the date is in the same week as today
        return currentWeek == dateWeek && currentYear == dateYear
    }

    var isFuture: Bool {
        stripTime() > Date.now.stripTime()
    }

    var isNowOrPast: Bool {
        stripTime() <= Date.now.stripTime()
    }

    var isPast: Bool {
        stripTime() < Date.now.stripTime()
    }

    var minute: Int {
        Calendar.gregorian.component(.minute, from: self)
    }

    var month: Int {
        Calendar.gregorian.component(.month, from: self)
    }

    var second: Int {
        Calendar.gregorian.component(.second, from: self)
    }

    var startOfMonth: Date {
        let calendar = Calendar.gregorian
        return calendar.date(from: calendar.dateComponents([.year, .month], from: stripTime())) ?? .now
    }

    var weekday: Int {
        Calendar.gregorian.component(.weekday, from: self)
    }

    var year: Int {
        Calendar.gregorian.component(.year, from: self)
    }
    
    func add(component: Calendar.Component, value: Int) -> Date {
        Calendar.gregorian.date(byAdding: component, value: value, to: self) ?? .now
    }

    func countDaysTo(to toDate: Date) -> Int {
        let dateComponents = Calendar.gregorian.dateComponents([.day],
                                                               from: Calendar.current.startOfDay(for: self),
                                                               to: Calendar.current.startOfDay(for: toDate))
        let remainingDays = dateComponents.day!
        return remainingDays
    }
    
    func customFormat(_ format: String) -> String {
        Date.getFormatter(dateFormat: format).string(from: self)
    }

    func formatAsMonthDay() -> String {
        Date.getFormatter(dateFormat: "MMM d").string(from: self)
    }

    func formatAsMonthDayHourMinute(is24HrFormat: Bool) -> String { // check here for 24 hr format
        Date.getFormatter(dateFormat: is24HrFormat ? "MMM d HH:mm" : "MMM d h:mm a").string(from: self)
    }

    func formatAsMonthDayYear() -> String {
        Date.getFormatter(dateFormat: "MMM d, yyyy").string(from: self)
    }

    func formatAsMonthYear() -> String {
        Date.getFormatter(dateFormat: "MMMM yyyy").string(from: self)
    }

    func formatAsShortMonthDayShortYear() -> String {
        Date.getFormatter(dateFormat: "MMM d, yy").string(from: self)
    }

    func formatAsShortMonthDayYear() -> String {
        Date.getFormatter(dateFormat: "MMM d, yyyy").string(from: self)
    }

    func formatAsShortMonthName() -> String {
        Date.getFormatter(dateFormat: "MMM").string(from: self)
    }

    func formatAsShortMonthYear() -> String {
        Date.getFormatter(dateFormat: "MMM yyyy").string(from: self)
    }

    func formatAsTime(is24HrFormat: Bool) -> String { // check here for 24 hr format
        Date.getFormatter(dateFormat: is24HrFormat ? "HH:mm" : "h:mm a").string(from: self)
    }

    func formatWithFullMonthName() -> String {
        Date.getFormatter(dateFormat: "MMMM d, yyyy").string(from: self)
    }

    func getDifferenceBetweenDateString(otherDate: Date) -> String {
        let daysDifference = Calendar.gregorian.dateComponents([.year, .month, .day], from: stripTime(), to: otherDate.stripTime())
        guard let year = daysDifference.year,
              let month = daysDifference.month,
              let day = daysDifference.day else { return "Unknown" }

        return "\(year == 0 ? "" : "\(year)y") \(month == 0 ? "" : "\(month)m") \(day == 0 ? "" : "\(day)d")"
    }

    static func generateDatesBetween(start: Date, end: Date) -> [Date] {
        var dates: [Date] = []
        var startDate = start
        while startDate <= end {
            dates.append(startDate)
            startDate = Calendar.gregorian.date(byAdding: .day, value: 1, to: startDate) ?? .now
        }

        return dates
    }

    static func getFormatter(dateFormat: String) -> DateFormatter {
        if let existingFormatter = formattersQueue.sync(execute: { formatters[dateFormat] }) {
            return existingFormatter
        }

        // If no formatter exists, create one
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = dateFormat
        newFormatter.locale = Locale(identifier: "en_US_POSIX")

        formattersQueue.async(flags: .barrier) { formatters[dateFormat] = newFormatter }

        return newFormatter
    }

    static func getNumberOfDays(month: Int, year: Int) -> Int {
        let calendar = Calendar.gregorian
        let date = Date(year: year, month: month)
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }

    static func randomDateBetween(_ start: Date, and end: Date) -> Date {
        let interval = start.timeIntervalSince1970
        let endInterval = end.timeIntervalSince1970

        // Ensure the lower bound is less than or equal to the upper bound
        guard interval <= endInterval else { return start }

        let randomInterval = Double.random(in: interval ... endInterval)
        return Date(timeIntervalSince1970: randomInterval)
    }

    func stripTime() -> Date {
        Calendar.gregorian.startOfDay(for: self)
    }
}

extension Date? {
    var safelyUnwrappedToNow: Date {
        self ?? .now
    }
    
    func safelyUnwrappedTo(date: Date) -> Date {
        self ?? date
    }
}
