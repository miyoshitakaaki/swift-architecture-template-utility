import Foundation

/// Data access object of keychain
///
/// ## Usage
/// ```swift
/// @KeychainStorage(key: "access_token_key")
/// static var accessToken: String?
/// ```
@propertyWrapper
public class KeychainStorage<T: LosslessStringConvertible> {
    private let key: String

    /// Initializes with the given key.
    /// - Parameter key: key of keychain value
    public init(key: String) {
        self.key = key
    }

    public var wrappedValue: T? {
        get {
            guard let result = Keychain().get(key) else { return nil }
            return T(result)
        }
        set {
            guard let new = newValue else { Keychain().remove(self.key)
                return
            }
            Keychain().set(String(new), key: self.key)
        }
    }
}

private struct Keychain {
    func get(_ key: String) -> String? {
        var query = query(key: key)

        query[String(kSecMatchLimit)] = kSecMatchLimitOne
        query[String(kSecReturnData)] = kCFBooleanTrue

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard errSecSuccess == status else { return nil }

        guard let data = result as? Data else { return nil }

        guard let string = String(data: data, encoding: .utf8) else { return nil }

        return string
    }

    func remove(_ key: String) {
        let query = query(key: key)
        SecItemDelete(query as CFDictionary)
    }

    func set(_ value: String, key: String) {
        guard let data = value.data(using: .utf8, allowLossyConversion: false) else {
            return
        }

        let query = query(key: key)

        let status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        case errSecSuccess, errSecInteractionNotAllowed:
            let query = self.query(key: key)
            let attributes = attributes(key: nil, value: data)
            SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        case errSecItemNotFound:
            let attributes = attributes(key: key, value: data)
            SecItemAdd(attributes as CFDictionary, nil)
        default:
            return
        }
    }

    private func query(key: String) -> [String: Any] {
        var query = [String: Any]()
        query[String(kSecClass)] = String(kSecClassGenericPassword)
        query[String(kSecAttrSynchronizable)] = kSecAttrSynchronizableAny
        query[String(kSecAttrService)] = Bundle.main.bundleIdentifier!
        query[String(kSecAttrAccount)] = key
        return query
    }

    private func attributes(key: String?, value: Data) -> [String: Any] {
        var attributes: [String: Any] = [:]

        if let key {
            attributes = self.query(key: key)
        }

        attributes[String(kSecValueData)] = value
        attributes[String(kSecAttrSynchronizable)] = kCFBooleanFalse

        return attributes
    }
}
