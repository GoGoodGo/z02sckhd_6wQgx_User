//
//  OnlinePayWayCell.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/1.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class OnlinePayWayCell: UITableViewCell {
    
    @IBOutlet weak var aliPay: UIButton!
    @IBOutlet weak var wxPay: UIButton!
    var selectedBtn: UIButton?
    var pay: ((_ type: String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectedBtn = aliPay
    }
    
    @IBAction func action_aliPay(_ sender: UIButton) {
        if let click = pay {
            click("1")
        }
    }
    
    @IBAction func action_wxPay(_ sender: UIButton) {
        if let click = pay {
            click("4")
        }
    }
    // MARK: - Setter
    override var frame: CGRect {
        didSet {
            let y: CGFloat = 10
            var tempFrame = frame
            tempFrame.origin.y += y
            tempFrame.size.height -= y
            super.frame = tempFrame
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
