//
//  IncomeCell.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/2.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class IncomeCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    let imgs = ["ico_img_ewm.png", "ico_img_hy.png", "ico_img_sy.png", "ico_img_txjl.png"]
    let names = ["我的二维码", "我的会员", "我的收益", "提现记录"]

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - Setter
    var index: Int = 0 {
        didSet {
            imgView.image = UIImage.init(named: imgs[index])
            name.text = names[index]
        }
    }
    
    override var frame: CGRect {
        didSet {
            let y: CGFloat = 10
            var tempFrame = frame
            tempFrame.origin.y += y
            super.frame = tempFrame
        }
    }
    
    
    
    
    
    
    
    
    
}
