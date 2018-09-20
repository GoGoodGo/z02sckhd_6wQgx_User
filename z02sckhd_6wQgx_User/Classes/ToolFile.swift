//
//  ToolFile.swift
//  AFNetworking
//
//  Created by Healson on 2018/9/20.
//

import Foundation
import YHTool

extension UIViewController {
    
    public func inspectLogin(model: BaseModel) {
        showAutoHideHUD(message: model.msg!) {
            if model.msg == "登录失效,请重新登录" {
//                let login = SetI001LoginViewController()
//                self.navigationController?.pushViewController(login, animated: true)
            }
        }
    }
}











