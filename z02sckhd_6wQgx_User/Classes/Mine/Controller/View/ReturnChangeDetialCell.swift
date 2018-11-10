//
//  ReturnChangeDetialCell.swift
//  z02sckhd_6wQgx_User
//
//  Created by Healson on 2018/10/29.
//

import UIKit

class ReturnChangeDetialCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var parameter: UILabel!
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var reason: UILabel!
    @IBOutlet weak var isAgree: UILabel!
    @IBOutlet weak var opinion: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    /** Set */
    var orderGoods: MyOrderGoods? {
        didSet {
            let url = URL.init(string: (orderGoods?.goods_image)!)
            imgView.kf.setImage(with: url, placeholder: nil)
            name.text = orderGoods?.goods_name
            parameter.text = orderGoods?.goods_attr
            price.text = "¥\(orderGoods?.goods_price ?? "0.0")"
            number.text = "X\(orderGoods?.goods_numbers ?? 1)"
            type.text = (orderGoods?.returninfo?.type == "1" ? "退货" : "换货")
            reason.text = orderGoods?.returninfo?.reson
            isAgree.text = (orderGoods?.returninfo?.status == "1" ? "同意" : "拒绝")
            opinion.text = orderGoods?.returninfo?.reply
            color.text = ""
        }
    }
    
    override var frame: CGRect {
        didSet {
            let y:CGFloat = 0
            var tempFrame = frame
            tempFrame.origin.y += y
            tempFrame.size.height -= 1
            super.frame = tempFrame
        }
    }
    
}
