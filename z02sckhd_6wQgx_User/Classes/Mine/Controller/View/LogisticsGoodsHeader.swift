//
//  LogisticsGoodsHeader.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/7.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class LogisticsGoodsHeader: UIView {
    
    @IBOutlet weak var orderID: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var name: UILabel!
    

    // MARK: - XIB View
    public class func headerView() -> Any? {
        
        return bundle(self).loadNibNamed(String(describing: self), owner: nil, options: nil)?.last
    }
    
    // MARK: - Setter
    var orderInfo: MyOrder? {
        didSet {
            name.text = orderInfo?.shopname
            orderID.text = "订单编号：\(orderInfo?.order_sn ?? "0000xxxx")"
            date.text = "发货时间：\(orderInfo?.deliver_time ?? "暂无")"
        }
    }
    
    override var frame: CGRect {
        didSet {
            let y:CGFloat = 10
            var tempFrame = frame
            tempFrame.origin.y += y
            tempFrame.size.height -= y
            super.frame = tempFrame
        }
    }
    
    
    
    
    
    
    
    

}
