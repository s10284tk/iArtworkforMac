//
//  ViewController.swift
//  iArtworkforMac
//
//  Created by piyo on 2017/05/01.
//  Copyright © 2017年 piyo. All rights reserved.
//

import Cocoa
import Alamofire
import AlamofireImage
import SwiftyJSON

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    
    private var Array: [(title: String, artist: String, album: String, url: String)] = []
    
    fileprivate enum cell {
        static let title = "titleCell"
        static let artist = "artistCell"
        static let album = "albumCell"
    }
    
    @IBAction func pushButton(_ sender: Any) {
        //初期化
        Array.removeAll()
        self.tableView.reloadData()
        
        //国選択
        let country = "us"
        
        if let search = textField?.stringValue {
            let listUrl = "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsSearch?"
            Alamofire.request(listUrl, parameters: [
                "term": search,
                "country": country,
                "entity": "musicTrack"
                ])
                .responseJSON{ response in
                    let json = JSON(response.result.value ?? 0)
                    json["results"].forEach{(i, data) in
                        let title: String = data["trackCensoredName"].stringValue
                        let artist: String = data["artistName"].stringValue
                        let album: String = data["collectionCensoredName"].stringValue
                        let url: String = data["artworkUrl60"].stringValue
                        let list = (title, artist, album, url)
                        self.Array.append(list)
                    }
                    self.tableView.reloadData()
            }
        }
        
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return Array.count
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cellIdentifier: String = ""
        var text: String = ""
        
        let item = Array[row]
        
        if tableColumn == tableView.tableColumns[0] {
            cellIdentifier = cell.title
            text = item.title
        } else if tableColumn == tableView.tableColumns[1] {
            cellIdentifier = cell.artist
            text = item.artist
        } else if tableColumn == tableView.tableColumns[2] {
            cellIdentifier = cell.album
            text = item.album
        }
        
        if let cellView = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cellView.textField!.stringValue = text
            return cellView
        }
        return nil
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

    override var representedObject: Any? {
        didSet {
        }
    }
    
    


}

