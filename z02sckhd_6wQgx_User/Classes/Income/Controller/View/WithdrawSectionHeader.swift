//
//  WithdrawSectionHeader.swift
//  TianMaUser
//
//  Created by YH_O on 2018/8/3.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class WithdrawSectionHeader: UIView {

    public class func sectionHeader() -> Any? {
        
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.last
    }
    
    
    override var frame: CGRect {
        didSet {
            var temp = frame
            temp.origin.y += 10
            super.frame = temp
        }
    }

}
