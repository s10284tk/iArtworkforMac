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
    @IBOutlet weak var segment: NSSegmentedControl!
    
    var itemTitle: String?
    var itemUrl: String?
    var clipBoard = NSPasteboard.general()
    let segArray: [ArtworkSize] = [.small, .medium, .large]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setupView()
    }

    // 最初にやる
    fileprivate func setupView() {
        guard let title = itemTitle else {
            return
        }
        label.stringValue = title
        imageSetup()
        // セグメント初期設定
        for (index, element) in segArray.enumerated() {
            segment.setLabel(element.title, forSegment: index)
        }
        segment.setSelected(true, forSegment: segment.selectedSegment)
    }
    
    fileprivate func imageSetup() {
        // サイズ選択
        let currentSize = ArtworkSize.currentSize
        let size = currentSize.parameter
        // 画像をセット
        let url = URL(string: itemUrl!.replacingOccurrences(of: "60x60bb.jpg", with: size))
        print(url!)
        self.itemImageView.kf.indicatorType = .activity
        self.itemImageView.kf.indicator?.startAnimatingView()
        self.itemImageView.kf.setImage(with: url)

    }
    
    // セグメント押したとき
    @IBAction func pushSeg(_ sender: Any) {
        DeviceData.imageSizeRawValue = segment.selectedSegment
        imageSetup()
    }
    
    // SAVEボタン
    @IBAction func save(_ sender: Any) {
        
        guard let title = self.itemTitle else { return }
        
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.showsTagField = false
        savePanel.nameFieldStringValue = "\(title).jpg"
        savePanel.begin { result in
            if result == NSFileHandlingPanelOKButton {
                guard let url = savePanel.url else { return }
                // ファイルに書き込む
                if let bits = self.itemImageView.image?.representations.first as? NSBitmapImageRep {
                    let data = bits.representation(using: .JPEG, properties: [:])
                    do {
                        try data?.write(to: url)
                        //ウィンドウを閉じる
                        self.view.window?.close()
                    } catch {
                        print("error")
                    }
                }
            }
        }
    }

    // ウィンドウを閉じる
    @IBAction func pushButton(_ sender: Any) {
        self.view.window?.close()
    }
    
    
    
}


