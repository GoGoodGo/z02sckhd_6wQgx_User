//
//  SingleInstance.swift
//  AFNetworking
//
//  Created by 虞淞晴 on 2019/3/8.
//

import UIKit

public class SingleInstance: NSObject {
    //在单例类中，有一个用来共享数据的数组
    public var datas = [String]()
    //创建一个静态或者全局变量，保存当前单例实例值
    public static let singleInstance = SingleInstance()
    //私有化构造方法
    public override init() {
        //给数组加一个原始数据
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(openArouseApp), name:
            NSNotification.Name("kTMAppDelegateHandleOpenURLNotification") , object: nil)
        
    }
    
    //提供一个公开的用来去获取单例的方法
    @objc public class func defaultSingleInstance() ->SingleInstance {
        //返回初始化好的静态变量值
        return singleInstance
    }
    
    
    
    @objc public func openArouseApp(noti:Notification){
        
        let kWindow = UIApplication.shared.keyWindow
        let vc = kWindow?.currentViewController()
        
//        let vc = kWindow?.rootViewController
        
        let url:URL = noti.object as! URL
        let str = url.absoluteString
        if str.contains("goods_id=") {
            
            let arr = str.components(separatedBy: "goods_id=")
            let goodsDetialCtrl = GoodsDetialController.init(nibName: "GoodsDetialController", bundle: getBundle())
            goodsDetialCtrl.goodsID = arr[1]
            goodsDetialCtrl.isPush = 1
           vc?.present(YHNavigaitonController.init(rootViewController:goodsDetialCtrl), animated: true, completion: nil)
//            vc?.navigationController?.pushViewController(, animated: true)
            
        }
    
        
    }
    
    
}
