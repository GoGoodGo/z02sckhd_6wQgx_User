//
//  MyOrderHeader.swift
//  TianMaUser
//
//  Created by YH_O on 2018/8/27.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class MyOrderHeader: UIView {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var state: UIButton!
    var type = 0

    public class func headerView() -> Any? {
        
        return bundle(self).loadNibNamed(String(describing: self), owner: nil, options: nil)?.last
    }

    var order: MyOrder? {
        didSet {
            title.text = order?.shopname
            state.isHidden = type != 0
        }
    }
    
    
    
    
    
    
}
