//
//  ChatDDDDViewController.swift
//  AFNetworking
//
//  Created by 虞淞晴 on 2019/3/6.
//

import UIKit
import RongIMKit

class ChatDDDDViewController: RCConversationViewController {

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.title = "联系客服"
        if #available(iOS 11.0, *) {
            self.conversationMessageCollectionView.contentInsetAdjustmentBehavior = .always

        }
        else{
            self.automaticallyAdjustsScrollViewInsets = true
        }
        

    }

    override func viewWillDisappear(_ animated: Bool) {
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isTranslucent = false
       
        var parent: UIViewController?
        var navigation:UINavigationController?
        if let window = UIApplication.shared.delegate?.window,let rootVC = window?.rootViewController {
            parent = rootVC
            while (parent?.presentedViewController != nil) {
                parent = parent?.presentedViewController!
            }
            
            if let tabbar = parent as? UITabBarController ,let nav = tabbar.selectedViewController as? UINavigationController {
                navigation = nav
            }else if let nav = parent as? UINavigationController {
                navigation = nav
            }
        }
        navigation?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        var parent: UIViewController?
//        var navigation:UINavigationController?
//        if let window = UIApplication.shared.delegate?.window,let rootVC = window?.rootViewController {
//            parent = rootVC
//            while (parent?.presentedViewController != nil) {
//                parent = parent?.presentedViewController!
//            }
//            
//            if let tabbar = parent as? UITabBarController ,let nav = tabbar.selectedViewController as? UINavigationController {
//                navigation = nav
//            }else if let nav = parent as? UINavigationController {
//                navigation = nav
//            }
//        }
//        navigation?.setNavigationBarHidden(true, animated: false)
        
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
