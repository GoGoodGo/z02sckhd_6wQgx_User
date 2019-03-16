//
//  GoodsDetialCell.swift
//  TianMaUser
//
//  Created by YH_O on 2018/7/28.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool

class GoodsDetialCell: UITableViewCell, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    
        let url = URLRequest.init(url: URL.init(string: "https://www.baidu.com")!)
        
        webView.loadRequest(url)
        webView.delegate = self
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
    
        let js = "var script = document.createElement('script');script.type = 'text/javascript';script.text = \"function ResizeImages() { var myimg,oldwidth;var maxwidth = \(WIDTH);for(i=0;i <document.images.length;i++){myimg = document.images[i];if(myimg.width > maxwidth){oldwidth = myimg.width;myimg.width = \(WIDTH - 15);}}}\";document.getElementsByTagName('head')[0].appendChild(script);"
        
        webView.stringByEvaluatingJavaScript(from: js)
        webView.stringByEvaluatingJavaScript(from: "ResizeImages();")
    }
    
    // MARK: - Setter
    var detial: String? {
        didSet {
            if detial == nil {
                return;
            }
         
            
            if detial!.contains("src=\"https:") {
                
                webView.loadHTMLString((detial?.replacingOccurrences(of: "<img src=\"", with: "<img width=\(WIDTH - 15) src=\"") ?? "暂无详情..."), baseURL:  nil)
                webView.loadHTMLString((detial?.replacingOccurrences(of: "width:", with: "width:\(WIDTH - 15)") ?? "..."), baseURL:  nil)
            }
            else{
                
                webView.loadHTMLString((detial?.replacingOccurrences(of: "<img src=\"", with: "<img width=\(WIDTH - 15) src=\"") ?? "暂无详情..."), baseURL:  URL.init(string: BASE_URL))
                webView.loadHTMLString((detial?.replacingOccurrences(of: "width:", with: "width:\(WIDTH - 15)") ?? "..."), baseURL:  URL.init(string: BASE_URL))
            }
                
                
                
            
//            webView.loadHTMLString(detial ?? "", baseURL:)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
