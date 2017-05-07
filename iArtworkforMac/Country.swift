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

