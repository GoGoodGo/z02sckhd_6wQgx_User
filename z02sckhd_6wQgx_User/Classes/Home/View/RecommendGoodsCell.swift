//
//  RecommendGoodsCell.swift
//  TianMaUser
//
//  Created by Healson on 2018/7/26.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import Kingfisher

class RecommendGoodsCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var describe: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var paidTotal: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
//        self.paidTotal.backgroundColor = UIColor.red
        
    }
    
    var goods: Goods? {
        didSet {
            let url = URL(string: (goods?.default_image ?? ""))
            img.kf.setImage(with: url, placeholder: nil)
            name.text = goods?.goods_name
            describe.text = ""
            price.text = "¥" + (goods?.price ?? "0.00")
//            paidTotal.text = "销量" + (goods?.pay_number ?? "0")
            paidTotal.text = " 可返现\(goods?.back_price ?? 0)元 "
        }
    }
    
    
    
    
    
    
    
    

}
