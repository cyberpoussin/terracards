//
//  UserDefaultsExtension.swift
//  TerraCards
//
//  Created by foxy on 21/05/2020.
//  Copyright © 2020 MacBookGP. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

extension UserDefaults {
    enum Keys: String {
        case nbLaunches, userName, userCards, allCards, lastFreeWins, nbQuizz, illimitedQuizz
    }
    
}

struct UserSettings {
    @UserDefault(UserDefaults.Keys.nbLaunches.rawValue, defaultValue: 0) static var nbLaunches: Int
    @UserDefault(UserDefaults.Keys.userName.rawValue, defaultValue: "username") static var userName: String
    @UserDefault(UserDefaults.Keys.userCards.rawValue, defaultValue: []) static var userCards: [String]
    @UserDefault(UserDefaults.Keys.allCards.rawValue, defaultValue: nil) static var allCards: Data?

    @UserDefault(UserDefaults.Keys.lastFreeWins.rawValue, defaultValue: "2001-12-31") static var lastFreeWins: String
    @UserDefault(UserDefaults.Keys.nbQuizz.rawValue, defaultValue: 0) static var nbQuizz: Int
    @UserDefault(UserDefaults.Keys.illimitedQuizz.rawValue, defaultValue: false) static var illimitedQuizz: Bool


}

