//
//  ArtwrokSize.swift
//  iArtworkforMac
//
//  Created by piyo on 2017/05/07.
//  Copyright © 2017年 piyo. All rights reserved.
//

import Foundation
import Cocoa

internal enum ArtworkSize {
    case small
    case medium
    case large
    
    static var currentSize: ArtworkSize {
        return ArtworkSize.artworkSize(DeviceData.imageSizeRawValue)
    }
    
    private static func artworkSize(_ rawValue: Int) -> ArtworkSize {
        switch rawValue {
        case 0:
            return .small
            
        case 1:
            return .medium
            
        case 2:
            return .large
            
        default:
            assertionFailure("ここには来ないはず")
            return .medium
        }
    }
    
    var rawValue: Int {
        switch self {
        case .small:
            return 0
        case .medium:
            return 1
        case .large:
            return 2
        }
    }
    
    var title: String {
        switch self {
        case .small:
            return "small"
        case .medium:
            return "medium"
        case .large:
            return "large"
        }
    }
    var parameter: String {
        switch self {
        case .small:
            return "600x600bb.jpg"
        case .medium:
            return "1200x1200bb.jpg"
        case .large:
            return "100000x100000-999.jpg"
        }
    }
}
