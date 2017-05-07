//
//  TitleCell.swift
//  iArtworkforMac
//
//  Created by piyo on 2017/05/01.
//  Copyright © 2017年 piyo. All rights reserved.
//

import Cocoa

internal final class TitleCell: NSTableCellView {

    var itemUrl: String?
    

    @IBOutlet weak var itemImageView: NSImageView!
    @IBOutlet weak var itemText: NSTextField!
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
}
