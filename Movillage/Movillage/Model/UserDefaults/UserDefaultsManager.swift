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

    func removeObject() { storage.removeObject(forKey: key) }
}

final class UserDefaultsManager {
    enum Key: String {
        case isStart, profileImage, nickname
    }
    @UserDefault(key: Key.isStart.rawValue, defaultValue: false, storage: .standard)
    static var didStart: Bool
    @UserDefault(key: Key.profileImage.rawValue, defaultValue: nil, storage: .standard)
    static var profileImage: String?
    @UserDefault(key: Key.nickname.rawValue, defaultValue: nil, storage: .standard)
    static var nickname: String?
}
