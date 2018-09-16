//
//  GoodsDetialCell.swift
//  TianMaUser
//
//  Created by YH_O on 2018/7/28.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool

class GoodsDetialCell: UITableViewCell {
    
    @IBOutlet weak var webView: UIWebView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    
        let url = URLRequest.init(url: URL.init(string: "https://www.baidu.com")!)
        webView.loadRequest(url)
    }
    
    // MARK: - Setter
    var detial: String? {
        didSet {
            webView.loadHTMLString((detial?.replacingOccurrences(of: "<img src=\"", with: "<img width=\(WIDTH - 15) src=\"http://shop.dktoo.com") ?? "暂无"), baseURL: nil)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
