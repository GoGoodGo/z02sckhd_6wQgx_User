//
//  NotEvaluateCell.swift
//  TianMaUser
//
//  Created by YH_O on 2018/9/11.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import Kingfisher

class NotEvaluateCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var param: UILabel!
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var price: UILabel!
    
    var evaluateBlock:((_ cell: NotEvaluateCell, _ goods: NotEvaluateGoods) -> Void)?
    var index = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    @IBAction func action_evaluate(_ sender: UIButton) {
        if let click = evaluateBlock {
            click(self, evaluate!)
        }
    }
    
    // MARK: - Setter
    var evaluate: NotEvaluateGoods? {
        didSet {
            let url = URL(string: (evaluate?.goods_image)!)
            imgView.kf.setImage(with: url)
            name.text = evaluate?.goods_name
            param.text = "规格：\(evaluate?.goods_attr ?? "暂无")"
            color.text = ""
            price.text = "¥ \(evaluate?.goods_price ?? "0.00")"
        }
    }
    
    override var frame: CGRect {
        didSet {
            let y: CGFloat = 10
            var tempFrame = frame
            tempFrame.origin.y -= y
            tempFrame.size.height -= y
            super.frame = tempFrame
        }
    }
    
    
    
    
    
    
    
    
    
    
}
