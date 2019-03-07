//
//  SSViewController.swift
//  z02sckhd_6wQgx_User_Example
//
//  Created by 虞淞晴 on 2019/3/6.
//  Copyright © 2019年 CocoaPods. All rights reserved.
//

import UIKit
import z02sckhd_6wQgx_User

class SSViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "测试"
        // Do any additional setup after loading the view.
        self.view.addSubview(btn)
        
  
        
        let className="z02sckhd_6wQgx_User" + "." + "HomeController"
        let viewC = NSClassFromString(className)! as!  HomeController.Type
        let vc=viewC.init()
        vc.perform(#selector(vc.arouseAppAction(url:)), with:URL.init(string: "tmapp://com.tenma.ventures.test/openwith?goods_id=601")!)
        
    }
    
    lazy var btn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 300))
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(doSomething), for: .touchUpInside)
        return btn
    }()
    
    @objc func doSomething(){
        self.navigationController?.pushViewController(YHTabBarController(), animated: true)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
