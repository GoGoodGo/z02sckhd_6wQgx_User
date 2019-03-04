//
//  CartGoodsCell.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/1.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import Kingfisher

class CartGoodsCell: UITableViewCell {
    
    @IBOutlet weak var selectedBtn: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var parameter: UILabel!
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var number: UILabel!
    
    var updateNum: (( _ cell: CartGoodsCell, _ num: Int) -> Void)?
    
    let btnTag = 111

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectedBtn.isSelected = selected
    }
    
    // MARK: - Callbacks
    @IBAction func action_updateNum(_ sender: UIButton) {
        
        let tag = sender.tag - btnTag
        var num = Int(number.text!)!
        switch tag {
        case 0:
            num -= 1
            if num <= 1 {
                num = 1
            }
        default:
            num += 1
        }
        if let click = updateNum {
            click(self, num)
        }
    }
    
    // MARK: - Setter
    var goods: CartGoods? {
        didSet {
            let url = URL.init(string: (goods?.goods_image)!)
            imgView.kf.setImage(with: url, placeholder: nil)
            name.text = goods?.goods_name
            parameter.text = goods?.specification
            price.text = "¥\(goods?.price ?? "0.0")"
            number.text = "\(goods?.quantity ?? 0)"
            color.text = ""
        }
    }
    
    
    
    
    
    
    
    
    
    
    
}
