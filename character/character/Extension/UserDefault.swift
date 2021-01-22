//
//  UserDefault.swift
//  character
//
//  Created by abimanyu on 22/01/21.
//

import UIKit

extension UserDefaults {
    /// Set codable into UserDefaults
    func setCodable<T: Codable>(data: T, forKey: String) -> Bool {
        if let encoded = try? JSONEncoder().encode(data) {
            self.set(encoded, forKey: forKey)
            return true
        }
        return false
    }
    
    /// Set [codable] into UserDefaults
    func setCodable<T: Codable>(data: [T], forKey: String) -> Bool {
        if let encoded = try? JSONEncoder().encode(data) {
            self.set(encoded, forKey: forKey)
            return true
        }
        return false
    }
    
    /// Get codable from UserDefaults
    func getCodable<T: Codable>(data: T.Type, forKey: String) -> T? {
        guard let savedData = self.object(forKey: forKey) as? Data else { return nil }
        guard let loadedData = try? JSONDecoder().decode(T.self, from: savedData) else { return nil }
        return loadedData
    }
    
    /// Get [codable] from UserDefaults
    func getCodable<T: Codable>(data: [T].Type, forKey: String) -> [T]? {
        guard let savedData = self.object(forKey: forKey) as? Data else { return nil }
        guard let loadedData = try? JSONDecoder().decode([T].self, from: savedData) else { return nil }
        return loadedData
    }
}

