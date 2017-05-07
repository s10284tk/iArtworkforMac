//
//  ImageViewController.swift
//  iArtworkforMac
//
//  Created by piyo on 2017/05/02.
//  Copyright © 2017年 piyo. All rights reserved.
//

import Cocoa
import Alamofire
import AlamofireImage
import Kingfisher

class ImageViewController: NSViewController {
    
    @IBOutlet weak private var label: NSTextField!
    @IBOutlet weak var itemImageView: NSImageView!
    
    var itemTitle: String?
    var itemUrl: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setupView()
    }
    
    //最初にやる
    fileprivate func setupView() {
        guard let title = itemTitle else {
            return
        }
        label.stringValue = title
        //画像をセット
        let url = URL(string: itemUrl!.replacingOccurrences(of: "60x60bb.jpg", with: "1500x1500bb.jpg"))
        self.itemImageView.kf.setImage(with: url)
    }
    
    @IBAction func pushButton(_ sender: Any) {
        self.view.window?.close()
    }
}
