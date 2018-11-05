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
    @IBOutlet weak var payFree: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var pay: UIButton!
    @IBOutlet weak var returnGoods: UIButton!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var payRight: NSLayoutConstraint!
    
    var payBlock: ((_ sender: UIButton, _ footer: OrderFooterView) -> Void)?
    var returnBlock: ((_ sender: UIButton, _ footer: OrderFooterView) -> Void)?
    var cancelBlock: ((_ sender: UIButton, _ footer: OrderFooterView) -> Void)?
    var touchBlock: ((_ footer: OrderFooterView) -> Void)?
    
    var section = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cancel.layer.borderColor = HexString("#d3d3d3").cgColor
        returnGoods.layer.borderColor = HexString("#d3d3d3").cgColor
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
    
    @IBAction func action_return(_ sender: UIButton) {
        
        if let click = returnBlock {
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
            integral.text = ""
//            integral.text = "可获得\(result?.give_integral ?? "0")个积分, 可使用\(result?.integral ?? "0")个积分"
//            let freight = result?._orders.first?.pay_fee ?? "0.00"
//            let total = Float(result?.order_amount ?? "0.00")! + Float(freight)!
            payFree.text = "¥\(result?.pay_fee ?? "0.00")"
            number.text = "共\(result?.total ?? "0")件商品"
            amount.text = "¥\(result?.order_amount ?? "0.00")"
        }
    }
    
    var state: Int = 0 {
        didSet {
            returnGoods.isHidden = true
            let btnW = (WIDTH - 45) / 3
            switch state {
            case 0:
                pay.isHidden = false
                cancel.isHidden = false
                returnGoods.isHidden = false
                payRight.constant = btnW + 30
                pay.setTitle("立即付款", for: .normal)
                returnGoods.setTitle("取消订单", for: .normal)
                cancel.setTitle("订单详情", for: .normal)
            case 1:
                pay.isHidden = true
                cancel.isHidden = false
                cancel.setTitle("订单详情", for: .normal)
            case 2:
                pay.isHidden = false
                cancel.isHidden = false
                returnGoods.isHidden = false
                payRight.constant = btnW + 30
                pay.setTitle("确认收货", for: .normal)
                returnGoods.setTitle("查看物流", for: .normal)
                cancel.setTitle("订单详情", for: .normal)
            case 3:
                pay.isHidden = true
                cancel.isHidden = false
                payRight.constant = 15
//                pay.setTitle("立即评价", for: .normal)
                cancel.setTitle("订单详情", for: .normal)
            case 4:
                pay.isHidden = true
                cancel.isHidden = false
                payRight.constant = 15
//                pay.setTitle("已完成", for: .normal)
                cancel.setTitle("订单详情", for: .normal)
                
            default: return
            }
        }
    }
    
    

}
