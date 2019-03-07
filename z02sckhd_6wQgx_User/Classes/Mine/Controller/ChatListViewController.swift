//
//  ChatListViewController.swift
//  AFNetworking
//
//  Created by 虞淞晴 on 2019/3/7.
//

import UIKit
import RongIMKit

class ChatListViewController: RCConversationListViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "聊天列表"
        self.setDisplayConversationTypes([RCConversationType.ConversationType_PRIVATE.rawValue, RCConversationType.ConversationType_GROUP.rawValue,RCConversationType.ConversationType_DISCUSSION.rawValue])
        
        view.backgroundColor = UIColor.white
        self.conversationListTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
    }
    
    //点击Cell用户聊天
    override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
        
        let chat = RCConversationViewController()//可以自己创建，也可以写原生控制器RCConversationViewController
        
        chat.conversationType = model.conversationType
        chat.targetId = model.targetId
        
        self.navigationController?.pushViewController(chat, animated:true)
    }
    
    override func didTapCellPortrait(_ model: RCConversationModel!) {
        print("%@",model)
    }
    
    
    
}
