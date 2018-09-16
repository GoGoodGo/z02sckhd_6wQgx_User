//
//  DetialBaseInfoCell.swift
//  TianMaUser
//
//  Created by YH_O on 2018/8/16.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class DetialBaseInfoCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var describe: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var stock: UILabel!
    @IBOutlet weak var sold: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    var goodsDetial: GoodsDetial? {
        didSet {
            name.text = goodsDetial?.goods_name
            describe.text = (goodsDetial?.spec_name_1 ?? "") + (goodsDetial?.spec_name_2 ?? "")
            price.text = "¥" + (goodsDetial?.price ?? "0")
            stock.text = "库存\(goodsDetial?.goods_number ?? "1")件"
            sold.text = "已售\(goodsDetial?.sales ?? "0")件"
        }
    }
    
    
    
    
    
    
    
}
