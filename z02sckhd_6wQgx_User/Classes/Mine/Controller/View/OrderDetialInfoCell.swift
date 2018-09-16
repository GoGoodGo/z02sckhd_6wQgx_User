//
//  OrderDetialInfoCell.swift
//  TianMaUser
//
//  Created by YH_O on 2018/8/11.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class OrderDetialInfoCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var message: UILabel!
    var result: MyOrderResult?

    override func awakeFromNib() {
        super.awakeFromNib()
    
        
    }
    
    // MARK: - Setter
    var index: Int = 0 {
        didSet {
            switch index {
            case 0:
                title.text = "创建时间"
                message.text = Date.dateWithSeconds(totalSeconds: Double((result?.add_time)!)!)
            case 1:
                title.text = "支付时间"
                message.text = Date.dateWithSeconds(totalSeconds: Double((result?.pay_time)!)!)
            case 2:
                title.text = "交易流水号"
                message.text = result?.order_sn
            case 3:
                title.text = "发货时间"
                message.text = Date.dateWithSeconds(totalSeconds: Double((result?._orders.first?.shipping_time)!)!)
            case 4:
                title.text = "物流编号"
                message.text = result?.order_sn
            case 5:
                title.text = "收货时间"
                message.text = Date.dateWithSeconds(totalSeconds: Double((result?._orders.first?.confirm_time)!)!)
            default:
                title.text = "评价时间"
                message.text = Date.dateWithSeconds(totalSeconds: Double((result?._orders.first?.evaluation_time)!)!)
            }
        }
    }
    
    override var frame: CGRect {
        didSet {
            let y:CGFloat = 10
            var tempFrame = frame
            tempFrame.origin.y += y
            tempFrame.size.height -= 1
            super.frame = tempFrame
        }
    }
    
}
