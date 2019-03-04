//
//  OrderDetialHeader.swift
//  TianMaUser
//
//  Created by YH_O on 2018/8/11.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class OrderDetialHeader: UIView {
    
    @IBOutlet weak var title: UILabel!
    
    public class func headerView() -> Any? {
        
        return bundle(self).loadNibNamed(String(describing: self), owner: nil, options: nil)?.last
    }
    
    // MARK: - Setter
    var section: Int = 0 {
        didSet {
            switch section {
            case 1:
                title.text = "交易明细"
            case 2:
                title.text = "退换货"
            default: break
            }
        }
    }
    
    override var frame: CGRect {
        didSet {
            let y:CGFloat = 10 * CGFloat(section)
            var tempFrame = frame
            tempFrame.origin.y += y
            tempFrame.size.height -= 0
            super.frame = tempFrame
        }
    }
    

}
