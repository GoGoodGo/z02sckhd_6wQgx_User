//
//  CartSectionFooter.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/1.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class CartSectionFooter: UIView {
    
    @IBOutlet weak var title: UILabel!
    

    // MARK: - XIB View
    public class func sectionFooter() -> Any? {
        
        return bundle(self).loadNibNamed(String(describing: self), owner: nil, options: nil)?.last
    }

}
