//
//  AppDelegate.swift
//  z02sckhd_6wQgx_User
//
//  Created by OYHHYO on 09/16/2018.
//  Copyright (c) 2018 OYHHYO. All rights reserved.
//

import UIKit
import z02sckhd_6wQgx_User

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        window?.rootViewController = YHTabBarController()
        window?.makeKeyAndVisible()
        
        WXApi.registerApp("wx7ba7fbd409123407")
        
        return true
    }
    
    /** Pay */
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (result) in
                self.payWithResult(result: result!)
            })
        }
        
        if url.host == "platformapi" {
            AlipaySDK.defaultService().processAuthResult(url, standbyCallback: { (result) in
                self.payWithResult(result: result!)
            })
        }
        
        if url.host == "pay" {
            return WXApi.handleOpen(url, delegate: self)
        }
        
        return true
    }
    
    // MARK: - WXApiDelegate
    func onResp(_ resp: BaseResp!) {
        if resp.isKind(of: PayResp.self) {
            let result = ["errorCode" : "\(resp.errCode)"]
            payWithResult(result: result)
        }
    }
    
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

