//
//  OrderGoodsCell.swift
//  TianMaUser
//
//  Created by Healson on 2018/7/31.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import Kingfisher
import YHTool

class OrderGoodsCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var parameter: UILabel!
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var isCheck: UIButton!
    @IBOutlet weak var imgLeft: NSLayoutConstraint!
    @IBOutlet weak var returnGoods: UIButton!
    @IBOutlet weak var returnGoodsW: NSLayoutConstraint!
    
    var returnBlock: ((_ cell: OrderGoodsCell) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        returnGoods.layer.borderColor = HexString("#efeff4").cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        isCheck.isSelected = selected
    }
    
    /** 退换货 */
    @IBAction func action_return(_ sender: UIButton) {
        
        if let click = returnBlock {
            click(self)
        }
    }
    
    
    // MARK: - Setter
    var cellType = 0 {
        didSet {
            returnGoods.setTitle(cellType == 3 ? "立即评价" : "退换货", for: .normal)
            returnGoods.isHidden = (cellType == 3 || cellType == 4) ? false : true
            returnGoodsW.constant = (cellType == 3 || cellType == 4) ? 60 : 0
        }
    }
    
    var goods: CartGoods? {
        didSet {
            let url = URL.init(string: (goods?.goods_image)!)
            imgView.kf.setImage(with: url, placeholder: nil)
            name.text = goods?.goods_name
            parameter.text = goods?.specification
            price.text = "¥\(goods?.price ?? "0.0")"
            number.text = "X\(goods?.quantity ?? "1")"
            color.text = ""
        }
    }
    
    var orderGoods: MyOrderGoods? {
        didSet {
            let url = URL.init(string: (orderGoods?.goods_image)!)
            imgView.kf.setImage(with: url, placeholder: nil)
            name.text = orderGoods?.goods_name
            parameter.text = orderGoods?.goods_attr
            price.text = "¥\(orderGoods?.goods_price ?? "0.0")"
            number.text = "X\(orderGoods?.goods_numbers ?? "1")"
            color.text = ""
            returnGoods.isEnabled = orderGoods?.goods_status != "1"
        }
    }
    
    var isOptional: Bool = false {
        didSet {
            isCheck.isHidden = !isOptional
            imgLeft.constant = isCheck.isHidden ? 15 : 45
        }
    }

    
    
}
