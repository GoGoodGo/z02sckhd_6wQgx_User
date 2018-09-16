//
//  CartSectionHeader.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/1.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class CartSectionHeader: UIView {
    
    @IBOutlet weak var title: UIButton!
    var selectedStore: ((_ sender: UIButton, _ header: CartSectionHeader) -> Void)?
    var section = 0

    // MARK: - XIB View
    public class func sectionHeader() -> Any? {
        
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.last
    }
    
    // MARK: - Callbacks
    @IBAction func action_selected(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if let click = selectedStore {
            click(sender, self)
        }
    }
    
    // MARK: - Setter
    override var frame: CGRect {
        didSet {
            let y:CGFloat = 10
            var tempFrame = frame
            tempFrame.origin.y += y
            tempFrame.size.height -= y
            super.frame = tempFrame
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            title.isSelected = isSelected
        }
    }
    
    
    
    
    

}
