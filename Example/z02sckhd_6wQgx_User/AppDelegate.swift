//
//  AppDelegate.swift
//  z02sckhd_6wQgx_User
//
//  Created by OYHHYO on 09/16/2018.
//  Copyright (c) 2018 OYHHYO. All rights reserved.
//

import UIKit
import z02sckhd_6wQgx_User
import TMPaySDK
import RongIMKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
//        window?.rootViewController = YHNavigaitonController.init(rootViewController: SSViewController())
        window?.rootViewController = YHTabBarController()
        window?.makeKeyAndVisible()
        
        RCIM.shared().initWithAppKey("sfci50a7s347i")
        ///是否将用户信息和群组信息在本地持久化存储
        RCIM.shared().enablePersistentUserInfoCache = false
        ///是否在发送的所有消息中携带当前登录的用户信息
        RCIM.shared().enableMessageAttachUserInfo = true
        
//        WXApi.registerApp("wxf5434529e3d5f55c")
        
        return true
    }
    
    /** Pay */
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        TMPayUtils.sharedInstance().tm_handlePayResult(withOpen: url, options: ["key" : "value"])
        
//        if url.host == "safepay" {
//            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (result) in
//                self.payWithResult(result: result!)
//            })
//        }
//        if url.host == "platformapi" {
//            AlipaySDK.defaultService().processAuthResult(url, standbyCallback: { (result) in
//                self.payWithResult(result: result!)
//            })
//        }
//        if url.host == "pay" {
//            return WXApi.handleOpen(url, delegate: self)
//        }
        
        return true
    }
    
    // MARK: - WXApiDelegate
//    func onResp(_ resp: BaseResp!) {
//        if resp.isKind(of: PayResp.self) {
//            let result = ["errorCode" : "\(resp.errCode)"]
//            payWithResult(result: result)
//        }
//    }
    
    /** 处理支付结果 */
    private func payWithResult(result: Dictionary<AnyHashable, Any>) {
        // 通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PayNotificationName), object: self, userInfo: result)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

