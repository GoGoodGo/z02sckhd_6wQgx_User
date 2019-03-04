//
//  CollectGoodsCell.swift
//  TianMaUser
//
//  Created by YH_O on 2018/8/11.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool
import Kingfisher

class CollectGoodsCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var describe: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var payNumber: UILabel!
    @IBOutlet weak var cancel: UIButton!
    
    var cancelBlock: ((_ cell: CollectGoodsCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - PrivateMethod
    private func setupUI() {
        
        cancel.layer.borderColor = HexString("#999999").cgColor
    }
    
    @IBAction func action_cancel(_ sender: UIButton) {
        if let click = cancelBlock {
            click(self)
        }
    }
    
    // MARK: - Setter
    var collect: Collect? {
        didSet {
            let url = URL.init(string: (collect?.default_image)!)
            imgView.kf.setImage(with: url, placeholder: nil)
            name.text = collect?.goods_name
            describe.text = " "
            price.text = "¥ \(collect?.price ?? "0.00")"
//            payNumber.text = "\(collect?.pay_number ?? 0)人付款"
            payNumber.text = " "
        }
    }
    
    
    
    
    
    

}
