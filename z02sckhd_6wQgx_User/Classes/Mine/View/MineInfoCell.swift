//
//  MineInfoCell.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/6.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class MineInfoCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    let imgs = ["ico_img_shdz.png", "ico_img_dd.png", "ico_img_sy1.png", "ico_img_tx.png", "ico_img_sc_blue.png"]
    let names = ["收货地址", "我的订单", "我的收益", "我的提现", "我的收藏"]

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    // MARK: - Setter
    var index: Int = 0 {
        didSet {
            img.image = UIImage.init(named: imgs[index])
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
