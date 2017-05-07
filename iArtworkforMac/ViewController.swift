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
import Kingfisher

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, NSTextFieldDelegate {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var popupButton: NSPopUpButton!

    private var Array: [(title: String, artist: String, album: String, url: String)] = []
    private let country: [String] = [Country.japan.title, Country.usa.title]
    
    fileprivate enum cell {
        static let title = "titleCell"
        static let artist = "artistCell"
        static let album = "albumCell"
    }

    @IBAction func selectPopupButton(_ sender: Any) {
        popupButton.title = (popupButton.selectedItem?.title)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        popupButton.addItems(withTitles: country)
    }
    


    @IBAction func pushEnter(_ sender: Any) {
        //初期化
        Array.removeAll()
        self.tableView.reloadData()
        
        //国選択
       let country: String
        guard let item = popupButton.selectedItem else {
            return
        }
        switch item.title {
        case "Japan":
            country = Country.japan.requestParameter
        case "USA":
            country = Country.usa.requestParameter
        default:
            country = Country.usa.requestParameter
        }
 
        
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
        var imageUrl: String = ""
        
        let item = Array[row]
        
        if tableColumn == tableView.tableColumns[0] {
            cellIdentifier = cell.title
            text = item.title
            imageUrl = item.url
            if let titleCell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? TitleCell {
                titleCell.itemUrl = imageUrl.replacingOccurrences(of: "60x60bb.jpg", with: "600x600bb.jpg")
                let url = URL(string: imageUrl)
                titleCell.itemImageView.kf.setImage(with: url)
                titleCell.itemText.stringValue = text
                return titleCell
            } else {
                return NSView()
            }
        } else if tableColumn == tableView.tableColumns[1] {
            cellIdentifier = cell.artist
            text = item.artist
            if let artistCell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
                artistCell.textField!.stringValue = text
                return artistCell
            } else {
                return NSView()
            }
        } else if tableColumn == tableView.tableColumns[2] {
            cellIdentifier = cell.album
            text = item.album
            if let albumCell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
                albumCell.textField!.stringValue = text
                return albumCell
            } else {
                return NSView()
            }
        } else {
            return NSView()
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let table = sender as? NSTableView {
            if let vc = segue.destinationController as? ImageViewController {
                print("hello")
                print(table.selectedRow)
                let cell = table.rowView(atRow: table.selectedRow, makeIfNecessary: false)?.view(atColumn: 0) as? TitleCell
                print(cell?.itemText.stringValue)
                let title = cell?.itemText.stringValue
                vc.itemTitle = title
                vc.itemUrl = cell?.itemUrl
            }
        }
    }
    


    


    override var representedObject: Any? {
        didSet {
        }
    }
    
    


}


