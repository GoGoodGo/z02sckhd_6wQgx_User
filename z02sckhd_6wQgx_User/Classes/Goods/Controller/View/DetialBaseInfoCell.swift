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
    
    @IBOutlet weak var returnMoneyLabel: UILabel!
    
    @IBOutlet weak var returnGoodsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    var goodsDetial: GoodsDetial? {
        didSet {
            name.text = goodsDetial?.goods_name
            describe.text = ""
            price.text = "¥" + (goodsDetial?.price ?? "0")
            stock.text = "库存\(goodsDetial?.goods_number ?? 1)件"
            sold.text = "已售\(goodsDetial?.sales ?? 0)件"
            
            if goodsDetial?.is_return == 1 {
                self.returnMoneyLabel.isHidden = false
                self.returnMoneyLabel.text = "  可退货  "
                self.returnGoodsLabel.isHidden = false
                self.returnGoodsLabel.text = " 可返现\(goodsDetial?.back_price ?? 0)元 "
            }
            else{
                self.returnMoneyLabel.isHidden = false
                self.returnMoneyLabel.text = " 可返现\(goodsDetial?.back_price ?? 0)元 "
                self.returnGoodsLabel.isHidden = true
                
            }
         
            
            
        }
    }
    
    
    
    
    
    
    
}
