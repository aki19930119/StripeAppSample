//
//  UserDataStore.swift
//  stripeAppSample
//
//  Created by 柿沼儀揚 on 2020/06/14.
//  Copyright © 2020 柿沼儀揚. All rights reserved.
//

import Foundation

class UserDataStore {
    private static let userDefaults = UserDefaults.standard
//    private static let userDefaults = "cus_HTPT6Ga92d5iPd"

    
    enum UserKeys: String {
        case stripeCustomerId
    }
    
    static func setString(_ key: UserKeys, string: String){
        userDefaults.set(string, forKey: key.rawValue)
    }
    
    static func getString(_ key: UserKeys) -> String? {
        guard let string = userDefaults.string(forKey: key.rawValue) else {
            return nil
        }
        return string
    }
}
