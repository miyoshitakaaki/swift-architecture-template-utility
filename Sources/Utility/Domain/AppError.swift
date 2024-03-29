import Foundation

public enum AppError: Error, Equatable, LocalizedError {
    case normal(title: String, message: String),
         auth(title: String, message: String),
         notice(title: String, message: String),
         none

    public var errorDescription: String? {
        switch self {
        case let .normal(_, message):
            return message
        case let .auth(_, message):
            return message
        case let .notice(_, message):
            return message
        case .none:
            return nil
        }
    }
}
