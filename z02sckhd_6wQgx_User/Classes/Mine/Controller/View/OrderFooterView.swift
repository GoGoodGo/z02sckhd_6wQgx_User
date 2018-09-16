//
//  OrderFooterView.swift
//  TianMaUser
//
//  Created by YH_O on 2018/8/6.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool

enum OrderState {
    case unpaid
    case unshipped
    case unreceived
    case notEvaluated
    case returnOrExchange
}

class OrderFooterView: UIView {
    
    @IBOutlet weak var integral: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var pay: UIButton!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var payRight: NSLayoutConstraint!
    
    var payBlock: ((_ sender: UIButton, _ footer: OrderFooterView) -> Void)?
    var cancelBlock: ((_ sender: UIButton, _ footer: OrderFooterView) -> Void)?
    var touchBlock: ((_ footer: OrderFooterView) -> Void)?
    
    var section = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cancel.layer.borderColor = HexString("#d3d3d3").cgColor
    }

    public class func footerView() -> Any? {
        
        return bundle(self).loadNibNamed(String(describing: self), owner: nil, options: nil)?.last
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let click = touchBlock {
            click(self)
        }
    }
    
    @IBAction func action_pay(_ sender: UIButton) {
        
        if let click = payBlock {
            click(sender, self)
        }
    }
    
    @IBAction func action_cancel(_ sender: UIButton) {
        if let click = cancelBlock {
            click(sender, self)
        }
        
    }
    
    // MARK: - Setter
    var result: MyOrderResult? {
        didSet {
            integral.text = "可获得\(result?.give_integral ?? "0")个积分, 可使用\(result?.integral ?? "0")个积分"
            number.text = "共\(result?.total ?? "0")件商品"
            amount.text = "¥\(result?.order_amount ?? "0.00")"
        }
    }
    
    var state: Int = 0 {
        didSet {
            switch state {
            case 0:
                pay.isHidden = false
                cancel.isHidden = false
                payRight.constant = 15
                pay.setTitle("立即付款", for: .normal)
                cancel.setTitle("取消订单", for: .normal)
            case 1:
                pay.isHidden = true
                cancel.isHidden = false
                cancel.setTitle("提醒发货", for: .normal)
            case 2:
                pay.isHidden = false
                cancel.isHidden = false
                payRight.constant = 15
                pay.setTitle("确认收货", for: .normal)
                cancel.setTitle("查看物流", for: .normal)
            case 3:
                cancel.isHidden = true
                pay.isHidden = false
                pay.setTitle("立即评价", for: .normal)
                payRight.constant = -100
            case 4:
                payRight.constant = -100
                cancel.isHidden = true
                pay.isHidden = false
                pay.setTitle("已完成", for: .normal)
                
            default: return
            }
        }
    }
    
    

}
