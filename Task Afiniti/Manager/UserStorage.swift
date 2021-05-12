//
//  UserStorage.swift
//  Task Afiniti
//
//  Created by Muhammad Danish Qureshi on 5/7/21.
//

import Foundation
class UserStorage {
    private var userDefault = UserDefaults.standard

    func getCounter() -> Int {
        return userDefault.integer(forKey: AfinityImageUserDefaultsKey.counter) 
    }
    func set(counter status: Int) {
        userDefault.setValue(status, forKey: AfinityImageUserDefaultsKey.counter)
    }
}
