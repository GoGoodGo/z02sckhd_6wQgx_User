//
//  OrderSectionFooter.swift
//  TianMaUser
//
//  Created by Healson on 2018/7/31.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class OrderSectionFooter: UIView {
    
    @IBOutlet weak var expressPrice: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var totalNum: UILabel!
    @IBOutlet weak var totoalPrice: UILabel!
    

    // MARK: - XIB View
    public class func footer() -> Any? {
        
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.last
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.delegate = self
    }
    
    // MARK: - Setter
    var store: CartStore? {
        didSet {
            totalNum.text = "共\(store?.totalQuantity ?? "0")件商品"
            totoalPrice.text = "¥\(store?.amount ?? 0.0)"
        }
    }

}

extension OrderSectionFooter: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        store?.notes = textField.text!
    }
    
}


















