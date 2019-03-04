//
//  OnlinePayOrderInfoCell.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/1.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class OnlinePayOrderInfoCell: UITableViewCell {
    
    @IBOutlet weak var orderID: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var amount: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    // MARK: - Setter
    var order: Order? {
        didSet {
            orderID.text = "订单编号：\(order?.order_sn ?? "00000001")"
            date.text = "创建时间：\(Date.currentDateStr())"
            amount.text = "¥\(order?.orderAmount ?? "0.00")"
        }
    }
    
    
    
    
    
    
    
}
