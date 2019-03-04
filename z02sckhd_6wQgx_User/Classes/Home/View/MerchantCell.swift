//
//  MerchantCell.swift
//  TianMaUser
//
//  Created by Healson on 2018/7/26.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import Kingfisher

class MerchantCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var salesLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    var shop: HomeShop? {
        didSet {
            let url = URL(string: (shop?.banner)!)
            imgView.kf.setImage(with: url)
            nameLabel.text = shop?.shopname
            rateLabel.text = ""
//            salesLabel.text = "销量\(shop?.sales ?? 0)件"
            salesLabel.text = ""
            totalLabel.text = "共\(shop?.total ?? 0)件宝贝"
        }
    }
    
    
    
    
    
    
    

}
