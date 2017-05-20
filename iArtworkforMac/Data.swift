//
//  Data.swift
//  iArtworkforMac
//
//  Created by piyo on 2017/05/08.
//  Copyright © 2017年 piyo. All rights reserved.
//

import Foundation
import Cocoa

internal struct DeviceData {
    
    private struct UserDefaultsKey {
        static let imageSize = "size"
        static let country = "country"
        static let genre = "genre"
    }
    
    private static let userDefaults = UserDefaults.standard
    
    static var imageSizeRawValue: Int {
        get {
            return userDefaults.integer(forKey: UserDefaultsKey.imageSize)
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKey.imageSize)
        }
    }
    
    static var countryRawValue: Int {
        get {
            return userDefaults.integer(forKey: UserDefaultsKey.country)
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKey.country)
        }
    }
    
    static var genreRawValue: Int {
        get {
            return userDefaults.integer(forKey: UserDefaultsKey.genre)
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKey.genre)
        }
    }

    
}
