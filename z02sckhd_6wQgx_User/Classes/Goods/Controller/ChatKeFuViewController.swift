//
//  ChatKeFuViewController.swift
//  AFNetworking
//
//  Created by 虞淞晴 on 2019/3/6.
//

import UIKit
import RongIMKit
import TMSDK
class ChatKeFuViewController: RCConversationViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.title = "联系客服"
        
        self.view.backgroundColor = UIColor.white
        
        
        // Do any additional setup after loading the view.
    }
    
    override init!(conversationType: RCConversationType, targetId: String!) {
        super.init(conversationType: conversationType, targetId: targetId)
        
        self.extensionView.frame = CGRect.init(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-200)
        self.conversationMessageCollectionView.frame = CGRect.init(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-200)
        self.chatSessionInputBarControl.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height-200, width: UIScreen.main.bounds.width, height: 50)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
