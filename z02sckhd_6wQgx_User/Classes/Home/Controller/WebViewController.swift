//
//  WebViewController.swift
//  AFNetworking
//
//  Created by 虞淞晴 on 2019/3/11.
//

import UIKit

class WebViewController: UIViewController {

    
    var url:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "详情"
      
        self.view.backgroundColor = UIColor.white
        self.webView.loadRequest(URLRequest.init(url: URL.init(string: url)!))
        
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isTranslucent = false
        
    
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
        
    }
    
    
    lazy var webView: UIWebView = {
        let view = UIWebView.init(frame: CGRect.init(x:0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-64))
        self.view.addSubview(view)
        return view
    }()


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
