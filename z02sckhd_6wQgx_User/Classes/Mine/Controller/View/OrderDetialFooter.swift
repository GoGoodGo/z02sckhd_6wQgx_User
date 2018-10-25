//
//  OrderDetialFooter.swift
//  TianMaUser
//
//  Created by YH_O on 2018/8/11.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class OrderDetialFooter: UIView {

    @IBOutlet weak var integral: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var payFree: UILabel!
    @IBOutlet weak var price: UILabel!
    
    public class func footerView() -> Any? {
        
        return bundle(self).loadNibNamed(String(describing: self), owner: nil, options: nil)?.last
    }
    // MARK: - Setter
    var result: MyOrderResult? {
        didSet {
//            integral.text = "可获得\(result?.give_integral ?? "0")个积分, 可使用\(result?.integral ?? "0")个积分"
            integral.text = ""
            let freight = result?._orders.first?.pay_fee ?? "0.00"
            let total = Float(result?.order_amount ?? "0.00")! + Float(freight)!
            payFree.text = "¥\(freight)"
            number.text = "共\(result?.total ?? "0")件商品"
            price.text = "¥\(total)"
        }
    }
    
    
    
    
    
    

}
