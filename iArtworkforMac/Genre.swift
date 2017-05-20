//
//  Genre.swift
//  iArtworkforMac
//
//  Created by piyo on 2017/05/21.
//  Copyright © 2017年 piyo. All rights reserved.
//

import Foundation
import Cocoa

enum Genre {
    case music
    case movie
    case tv
    
    static var currentGenre: Genre {
        return Genre.genre(DeviceData.genreRawValue)
    }
    
    private static func genre (_ rawValue: Int) -> Genre {
        switch rawValue {
        case 0:
            return .music
        case 1:
            return .movie
        case 2:
            return .tv
        default:
            assertionFailure("ここには来ないはず")
            return .music
        }
    }
    
    var rawValue: Int {
        switch self {
        case .music:
            return 0
        case .movie:
            return 1
        case .tv:
            return 2
        }
    }
    
    var title: String {
        switch self {
        case .music:
            return "Music"
        case .movie:
            return "Movie"
        case .tv:
            return "TV"
        }
    }
    
    var requestParameter: String {
        switch self {
        case .music:
            return "musicTrack"
        case .movie:
            return "movie"
        case .tv:
            return "tvshow"
        }
    }
}
