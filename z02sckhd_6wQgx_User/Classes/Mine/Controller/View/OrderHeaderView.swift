//
//  OrderHeaderView.swift
//  TianMaUser
//
//  Created by YH_O on 2018/8/6.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class OrderHeaderView: UIView {
    
    @IBOutlet weak var orderID: UILabel!
    @IBOutlet weak var date: UILabel!
    
    var section = 0
    
    var touchBlock: ((_ footer: OrderHeaderView) -> Void)?

    public class func headerView() -> Any? {
        
        return bundle(self).loadNibNamed(String(describing: self), owner: nil, options: nil)?.last
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let click = touchBlock {
            click(self)
        }
    }
    
    // MARK: - Setter
    var result: MyOrderResult? {
        didSet {
            orderID.text = "订单编号: \(result?.order_sn ?? "00000001")"
            let seconds: TimeInterval = Double((result?.add_time)!)!
            date.text = "创建时间: \(Date.dateWithSeconds(totalSeconds: seconds, formatter: "yyyy-MM-dd"))"
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
