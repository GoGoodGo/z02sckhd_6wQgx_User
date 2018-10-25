//
//  OrderGoodsCell.swift
//  TianMaUser
//
//  Created by Healson on 2018/7/31.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import Kingfisher

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
    
    var returnBlock: ((_ cell: OrderGoodsCell) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
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
            returnGoods.isHidden = cellType != 4
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
        }
    }
    
    var isOptional: Bool = false {
        didSet {
            isCheck.isHidden = !isOptional
            imgLeft.constant = isCheck.isHidden ? 15 : 45
        }
    }

    
    
}
