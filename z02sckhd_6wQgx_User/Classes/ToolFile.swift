//
//  ToolFile.swift
//  AFNetworking
//
//  Created by Healson on 2018/9/20.
//

import Foundation
import YHTool
import TMSDK
import SetI001

extension UIViewController {
    
    public func inspectLogin(model: BaseModel) {
//        showAutoHideHUD(message: model.msg!) {
            if model.msg == "登录失效,请重新登录" {
                
                let login = SetI001LoginViewController()
                self.navigationController?.pushViewController(login, animated: true)
                
            }
//        }
    }
    
    func inspectLogin() -> Bool {
        if TMHttpUserInstance.sharedManager()?.member_id == 0 {
            let login = SetI001LoginViewController()
            self.navigationController?.pushViewController(login, animated: true)
            return false
        }
        return true
    }
    
    @objc func login(notifi: Notification) {
        let login = SetI001LoginViewController()
        self.navigationController?.pushViewController(login, animated: true)
    }
    
}

public extension UIWindow {
    
    public func topMostWindowController()->UIViewController? {
        
        var topController = rootViewController
        
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        
        return topController
    }
    
    public func currentViewController()->UIViewController? {
        
        var currentViewController = topMostWindowController()
        if currentViewController is UITabBarController{
            currentViewController = (currentViewController as! UITabBarController).selectedViewController
        }
        while currentViewController != nil && currentViewController is UINavigationController && (currentViewController as! UINavigationController).topViewController != nil {
            currentViewController = (currentViewController as! UINavigationController).topViewController
        }
        
        return currentViewController
    }
}

