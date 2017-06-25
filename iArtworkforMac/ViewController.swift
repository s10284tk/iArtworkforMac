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
import Kingfisher

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, NSTextFieldDelegate {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var popupButton: NSPopUpButton!
    @IBOutlet weak var segment: NSSegmentedControl!

    private var Array: [(title: String, artist: String, album: String, url: String)] = []
    private let country: [String] = [Country.japan.title, Country.usa.title]
    private let genre: [Genre] = [.music, .movie, .tv]
    
    fileprivate enum cell {
        static let title = "titleCell"
        static let artist = "artistCell"
        static let album = "albumCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        //ポップアップ初期設定
        let currentCountry = Country.currentCountry
        popupButton.addItems(withTitles: country)
        popupButton.selectItem(at: currentCountry.rawValue)
        
        // セグメント初期設定
        for (index, elements) in genre.enumerated() {
            segment.setLabel(elements.title, forSegment: index)
        }
        let currentGenre = Genre.currentGenre
        segment.setSelected(true, forSegment: currentGenre.rawValue)
    }
    
    // pushSelectPopupButton
    @IBAction func selectPopupButton(_ sender: Any) {
        
        guard let title = popupButton.selectedItem?.title else {
            return
        }
        popupButton.title = title
        DeviceData.countryRawValue = popupButton.indexOfSelectedItem
        print(popupButton.indexOfSelectedItem)
    }
    
    // selectSegmentedController
    @IBAction func selectSegment(_ sender: Any) {
        DeviceData.genreRawValue = segment.selectedSegment
    }


    @IBAction func pushEnter(_ sender: Any) {
        // 初期化
        Array.removeAll()
        self.tableView.reloadData()
        
        // 国選択
        let country: String
        let currentCountry = Country.currentCountry
        country = currentCountry.requestParameter
        
        // ジャンル選択
        let genre: String
        let currentGenre = Genre.currentGenre
        genre = currentGenre.requestParameter
 
        // JSON処理のCodable準備
        struct Json: Codable {
            let results: [SongData]
            struct SongData: Codable{
                let trackCensoredName: String
                let artistName: String
                let collectionCensoredName: String
                let artworkUrl60: String
            }
        }
        
        if let search = textField?.stringValue {
            let listUrl = "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsSearch?"
            Alamofire.request(listUrl, parameters: [
                "term": search,
                "country": country,
                "entity": genre
                ])
                .responseData{ response in
                    // codableでデコード
                    guard let jsonData = response.result.value else {
                        print("data is nil")
                        return
                    }
                    let decoder: JSONDecoder = JSONDecoder()
                    do {
                        let decodedJson: Json = try decoder.decode(Json.self, from: jsonData)
                        for (_, element) in decodedJson.results.enumerated(){
                            let title: String = element.trackCensoredName
                            let artist: String = element.artistName
                            let album: String = element.collectionCensoredName
                            let url: String = element.artworkUrl60
                            let list = (title, artist, album, url)
                            self.Array.append(list)
                        }
                        
                        print(decodedJson.results[0].trackCensoredName)
                    } catch {
                        print("json decode faild")
                    }
                    self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - NSTableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return Array.count
    }
    
    // MARK: - NSTableViewDelegate
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cellIdentifier: String = ""
        var text: String = ""
        var albumInfo: String = ""
        var imageUrl: String = ""
        
        let item = Array[row]
        
        if tableColumn == tableView.tableColumns[0] {
            cellIdentifier = cell.title
            text = item.title
            imageUrl = item.url
            albumInfo = item.album
            if let titleCell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? TitleCell {
                titleCell.itemUrl = imageUrl
                let url = URL(string: imageUrl)
                titleCell.itemImageView.kf.setImage(with: url)
                titleCell.itemText.stringValue = text
                titleCell.album = albumInfo
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
                print(cell?.album ?? "error")
                let title = cell?.album
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


