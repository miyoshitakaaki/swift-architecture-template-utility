import Foundation

extension TimeZone {
    static let japan = TimeZone(identifier: "Asia/Tokyo")!
}

extension Locale {
    static let japan = Locale(identifier: "ja_jp")
}

public enum DateFormat: String {
    case dashDate = "yyyy-MM-dd"
    case dashDateTime = "yyyy-MM-dd HH:mm:ss"
    case slashDate = "yyyy/MM/dd"
    case slashDateTime = "yyyy/MM/dd HH:mm:ss"
    case dotDate = "yyyy.MM.dd"
    case yyyyMdDate = "yyyy.M.d"
    case yyyyMdHmDate = "yyyy.MM.dd HH:mm"
    case dotDateTime = "yyyy.MM.dd HH:mm:ss"
    case japanese = "yyyy年MM月dd日"

    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = .japan
        formatter.locale = .japan
        formatter.dateFormat = self.rawValue

        var calender = Calendar(identifier: .gregorian)
        calender.locale = .current
        formatter.calendar = calender
        return formatter
    }
}

public enum ISO8601DateFormat {
    case iso8601
    case iso8601withMilliseconds

    var formatter: ISO8601DateFormatter {
        switch self {
        case .iso8601:
            return ISO8601DateFormatter()

        case .iso8601withMilliseconds:
            let f = ISO8601DateFormatter()
            f.formatOptions.insert(.withFractionalSeconds)
            return f
        }
    }
}

public extension String {
    func date(from format: DateFormat) -> Date? {
        format.formatter.date(from: self)
    }

    func date(from format: ISO8601DateFormat) -> Date? {
        format.formatter.date(from: self)
    }
}

public extension Date {
    func string(to format: DateFormat) -> String {
        format.formatter.string(from: self)
    }

    func string(to format: ISO8601DateFormat) -> String {
        format.formatter.string(from: self)
    }
}
