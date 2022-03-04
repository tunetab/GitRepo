//
//  KeyValueStorage.swift
//  GitRepo
//
//  Created by Стажер on 04.03.2022.
//

import Foundation

class KeyValueStorage {
    enum Setting {
        static let authToken = "token"
        static let username = "username"
    }
    
    static var shared = KeyValueStorage()
    private var defaults = UserDefaults.standard
    
    private func archiveJSON<T: Encodable>(value: T, key: String) {
        let data = try! JSONEncoder().encode(value)
        let string = String(data: data, encoding: .utf8)
        defaults.set(string, forKey: key)
    }
    
    private func unarchiveJSON<T: Decodable>(key: String) -> T? {
        guard let string = defaults.string(forKey: key),
              let data = string.data(using: .utf8) else { return nil }
        return try! JSONDecoder().decode(T.self, from: data)
    }
    
    var authToken: String? {
        get {
            unarchiveJSON(key: Setting.authToken) ?? ""
        }
        set {
            archiveJSON(value: newValue, key: Setting.authToken)
        }
    }
    var userName: String? {
        get {
            unarchiveJSON(key: Setting.username) ?? ""
        }
        set {
            archiveJSON(value: newValue, key: Setting.username)
        }
    }
}

