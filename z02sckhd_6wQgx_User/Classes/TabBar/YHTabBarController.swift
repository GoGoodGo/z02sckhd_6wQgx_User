//
//  YHTabBarController.swift
//
//  Created by YH_O on 2017/3/9.
//  Copyright © 2017年 OYH. All rights reserved.
//

import UIKit
import YHTool
import TMSDK

public class YHTabBarController: UITabBarController {

    let vcs = [HomeController(), GoodsController(), CartController(), IncomeController(), MineController()]
    let vcNameList = [".HomeController", ".GoodsController", "CartController", "IncomeController", "MineController"]
    let titleList = ["首页", "商品", "购物车", "收益", "我的"]
    let normalImgList = ["ico_img_indexw", "ico_img_spw", "ico_img_gwcw", "ico_img_wdsyw", "ico_img_wdw"]
    let selectedImgList = ["ico_img_index", "ico_img_sp", "ico_img_gwc", "ico_img_wdsy", "ico_img_wd"]
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        self.delegate = self
    }
    
    // MARK: - 配置子视图
    private func setupSubviews() {
        
        let itemAppearance = UITabBarItem.appearance()
        itemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : HexString("#cccccc")], for: .normal)
        itemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : HexString("#ff5863")], for: .selected)
        
        for (index, name) in vcNameList.enumerated() {
            
            let bundle = getBundle()
            
            var VC: UIViewController? = nil
            if index >= 2 {
                VC = (NSClassFromString(bundle.infoDictionary!["CFBundleName"] as! String + "." + name) as! UIViewController.Type).init(nibName: name, bundle: bundle)
            } else {
                let ctrlName = bundle.infoDictionary!["CFBundleName"] as! String + name
                VC = (NSClassFromString(ctrlName) as! UIViewController.Type).init()
            }
            
            VC?.tabBarItem.title = self.titleList[index]
            VC?.tabBarItem.image = getImage(type(of: self), normalImgList[index])
            VC?.tabBarItem.selectedImage = getImage(type(of: self), selectedImgList[index])?.withRenderingMode(.alwaysOriginal)
            let navigationCtrl = UINavigationController.init(rootViewController: VC!)
            navigationCtrl.title = self.titleList[index]
            
            addChild(navigationCtrl)
        }
        self.setValue(YHTabBar(), forKeyPath: "tabBar")
    }
}

extension YHTabBarController: UITabBarControllerDelegate {
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == tabBarController.viewControllers?[2] || viewController == tabBarController.viewControllers?[3] || viewController == tabBarController.viewControllers?[4] {
            if TMHttpUserInstance.sharedManager()?.member_id == 0 {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "login"), object: self, userInfo: nil)
                return false
            }
        }
        return true
    }
    
}
