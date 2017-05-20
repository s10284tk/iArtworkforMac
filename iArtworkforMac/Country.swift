//
//  Country.swift
//  iArtworkforMac
//
//  Created by piyo on 2017/05/07.
//  Copyright © 2017年 piyo. All rights reserved.
//

import Foundation
import Cocoa

internal enum Country {
    case japan
    case usa
    
    static var currentCountry: Country {
        return Country.country(DeviceData.countryRawValue)
    }
    
    private static func country(_ rawValue: Int) -> Country {
        switch rawValue {
        case 0:
            return .japan
            
        case 1:
            return .usa
            
        default:
            assertionFailure("ここには来ないはず")
            return .japan
        }
    }
    
    var rawValue: Int {
        switch self {
        case .japan:
            return 0
            
        case .usa:
            return 1
        }
    }
    
    var title: String {
        switch self{
        case .japan:
            return "Japan"
        case .usa:
            return "USA"
        }
    }
    var requestParameter: String {
        switch self {
        case .japan:
            return "jp"
        case .usa:
            return "us"
        }
    }
}

