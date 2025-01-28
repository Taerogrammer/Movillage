import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    let storage: UserDefaults

    var wrappedValue: T {
        get { self.storage.object(forKey: self.key) as? T ?? self.defaultValue }
        set { self.storage.set(newValue, forKey: self.key) }
    }
}

final class UserDefaultsManager {
    enum Key: String {
        case isStart
    }
    @UserDefault(key: Key.isStart.rawValue, defaultValue: false, storage: .standard)
    static var didStart: Bool
}
