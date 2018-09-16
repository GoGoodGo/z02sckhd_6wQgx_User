//
//  LogisticsGoodsFooter.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/7.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class LogisticsGoodsFooter: UIView {
    
    @IBOutlet weak var integral: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    
    // MARK: - XIB View
    public class func footerView() -> Any? {
        
        return bundle(self).loadNibNamed(String(describing: self), owner: nil, options: nil)?.last
    }

}
