import Foundation

/// Data access object of UserDefault
///
/// ## Usage
/// ```swift
/// @UserDefaultsStorage(key: "is_login")
/// static var isLogin: String?
/// ```
@propertyWrapper
public struct UserDefaultsStorage<T: LosslessStringConvertible> {
    private let key: String

    /// Initializes with the given key.
    /// - Parameter key: key of UserDefault value
    public init(key: String) {
        self.key = key
    }

    public var wrappedValue: T? {
        get {
            UserDefaults.standard.object(forKey: self.key) as? T
        }
        set {
            UserDefaults.standard.set(newValue, forKey: self.key)
        }
    }
}
