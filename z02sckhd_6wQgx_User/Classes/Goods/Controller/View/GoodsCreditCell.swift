//
//  GoodsCreditCell.swift
//  TianMaUser
//
//  Created by Healson on 2018/7/27.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class GoodsCreditCell: UITableViewCell {

    @IBOutlet weak var available: UILabel!
    
    @IBOutlet weak var useable: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - Setter
    var goodsDetial: GoodsDetial? {
        didSet {
            available.text = goodsDetial?.give_integral == "-1" ? "0" : goodsDetial?.give_integral
            useable.text = goodsDetial?.rank_integral == "-1" ? "0" : goodsDetial?.rank_integral
        }
    }
    
    override var frame: CGRect {
        didSet {
            let y: CGFloat = 5
            var tempFrame = frame
            tempFrame.origin.y += y
            tempFrame.size.height -= y
            super.frame = tempFrame
        }
    }
    
    
    
    
    
    
    
    
    
    
}
