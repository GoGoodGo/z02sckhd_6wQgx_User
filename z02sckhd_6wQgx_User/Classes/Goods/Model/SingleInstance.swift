//
//  SingleInstance.swift
//  AFNetworking
//
//  Created by 虞淞晴 on 2019/3/8.
//

import UIKit
import RongIMKit
import YHTool
import TMSDK

public class SingleInstance: NSObject,RCIMUserInfoDataSource {
  
    
    //在单例类中，有一个用来共享数据的数组
    public var datas = [String]()
    //创建一个静态或者全局变量，保存当前单例实例值
    public static let singleInstance = SingleInstance()
    
    var head = ""
    
    var name = ""
    
    var userID = ""
    
    //私有化构造方法
    public override init() {
        //给数组加一个原始数据
        super.init()
        
        RCIM.shared().initWithAppKey("sfci50a7s347i")
        RCIM.shared()?.userInfoDataSource = self
        ///是否将用户信息和群组信息在本地持久化存储
        RCIM.shared().enablePersistentUserInfoCache = true
        ///是否在发送的所有消息中携带当前登录的用户信息
        RCIM.shared().enableMessageAttachUserInfo = true
        RCIMClient.shared()?.initWithAppKey("sfci50a7s347i")
        
        NotificationCenter.default.addObserver(self, selector: #selector(openArouseApp), name:
            NSNotification.Name("kTMAppDelegateHandleOpenURLNotification") , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(successLogin), name:
            NSNotification.Name("SetI001_Notification_Login") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeLogin), name:
            NSNotification.Name("SetI001_Notification_Logout") , object: nil)
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
            
        }
        
        
        
    }
    @objc func successLogin(){
        loadUserDetial()
    }
    @objc func removeLogin(){
        RCIM.shared()?.disconnect()
    }
    
    func loadUserDetial() {
        NetworkingManager.getRequest(baseUrl: UserDetial_URL, params: ["token" : TMHttpUser.token() ?? TestToken], success: { [weak self] (obj: UserInfo) in
            if "success" == obj.status {
                //                Singleton.shared.rongyun_token =
                self?.loginRongYun(str: (obj.data?.rongyun_token)!)
                
                self?.userID = "\((obj.data?.user_id)!)"
                let user = TMHttpUserInstance.sharedManager()
                let config = TMEngineConfig.instance()
                let head_pic = user?.head_pic ?? ""
                self?.head = (head_pic.contains("://") ? "" : (config?.domain)!) + head_pic
                if let nickname = user?.member_nickname {
                    self?.name = nickname.isEmpty ? "\(user?.mobile ?? "")" : "\(nickname)"
                }
            }
        }) { (error) in
//            self.inspectError()
        }
    }
    
    
    func loginRongYun(str:String){
        RCIM.shared()?.connect(withToken: str, success: { (userId) in
            print("登录成功-----token:\(userId ?? "")")
            
            let currentUserInfo = RCUserInfo(userId: userId!, name: self.name, portrait: self.head)
            ///将设置的用户信息赋值给登录账号
            RCIM.shared().currentUserInfo = currentUserInfo
            
        }, error: { (status) in
            //            self.showAutoHideHUD(message: "融云链接失败")
            
        }, tokenIncorrect: {
            //            self.showAutoHideHUD(message: "融云链接失败")
            
        })
    }
    
    @objc public func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {

        
        if RCIM.shared()?.getUserInfoCache(userId) != nil {
            
            return
            
        }
        
        var dic  = [String:String]()
        if userID.contains("s") {
            dic = ["sid":userID]
        }
        else{
            dic = ["uid":userID]
            
        }
        NetworkingManager.getRequest(baseUrl: RUserDetial_URL, params: dic, success: { [weak self] (obj: RUserInfo) in
            if "success" == obj.status {
                let user = RCUserInfo()
                
                if userId.contains("s") {
                    user.userId = obj.data?.seller?.userid
                    user.portraitUri = obj.data?.seller?.head_pic
                    user.name = obj.data?.seller?.username
                }
                else{
                    user.userId = obj.data?.user?.userid
                    user.portraitUri = obj.data?.user?.head_pic
                    user.name = obj.data?.user?.username
                    
                }
                
                
                completion(user)
                
                
            }
        }) { (error) in
            //            self.inspectError()
        }
        
    }
    

    
    
}
