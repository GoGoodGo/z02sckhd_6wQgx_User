//
//  YHTabBarController.swift
//
//  Created by YH_O on 2017/3/9.
//  Copyright © 2017年 OYH. All rights reserved.
//

import UIKit
import YHTool

public class YHTabBarController: UITabBarController {

    let vcNameList = [".HomeController", ".GoodsController", "CartController", "IncomeController", "MineController"]
    let titleList = ["首页", "商品", "购物车", "收益", "我的"]
    let normalImgList = ["ico_img_indexw", "ico_img_spw", "ico_img_gwcw", "ico_img_wdsyw", "ico_img_wdw"]
    let selectedImgList = ["ico_img_index", "ico_img_sp", "ico_img_gwc", "ico_img_wdsy", "ico_img_wd"]
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    // MARK: - 配置子视图
    private func setupSubviews() {
        
        let itemAppearance = UITabBarItem.appearance()
        itemAppearance.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : HexString("#cccccc")], for: .normal)
        itemAppearance.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : HexString("#ff5863")], for: .selected)
        
        for (index, name) in vcNameList.enumerated() {
            
            let bundle = Bundle.init(for: type(of: self))
            let ctrlName = bundle.infoDictionary!["CFBundleExecutable"] as! String + name
            
            var VC: UIViewController? = nil
            if index >= 2 {
                let url = bundle.url(forResource: "z02sckhd_6wQgx_User", withExtension: "bundle")
                
                VC = (NSClassFromString(bundle.infoDictionary!["CFBundleExecutable"] as! String + "." + name) as! UIViewController.Type).init(nibName: name, bundle: Bundle.init(url: url!))
            } else {
                VC = (NSClassFromString(ctrlName) as! UIViewController.Type).init()
            }
            
            VC?.tabBarItem.title = self.titleList[index]
            VC?.tabBarItem.image = getImage(type(of: self), normalImgList[index])
            VC?.tabBarItem.selectedImage = getImage(type(of: self), selectedImgList[index])?.withRenderingMode(.alwaysOriginal)
            let navigationCtrl = YHNavigaitonController.init(rootViewController: VC!)
            navigationCtrl.title = self.titleList[index]
            
            addChildViewController(navigationCtrl)
        }
        self.setValue(YHTabBar(), forKeyPath: "tabBar")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
