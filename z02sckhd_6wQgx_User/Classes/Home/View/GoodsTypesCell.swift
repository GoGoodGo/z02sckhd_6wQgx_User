//
//  GoodsTypesCell.swift
//  TianMaUser
//
//  Created by Healson on 2018/7/25.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import Kingfisher

class GoodsTypesCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    let images = ["ico_img_nz.png", "ico_img_xz.png", "ico_img_tz.png", "ico_img_mz.png", "ico_img_sp.png", "ico_img_bh.png", "ico_img_jd.png", "ico_img_gd.png"]
    let names = ["暂无", "暂无", "暂无", "暂无", "暂无", "暂无", "暂无", "暂无"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    // MARK: - Setter
    var category: CategoryInfo? {
        didSet {
            let url = URL(string: (category?.image)!)
            imageView.kf.setImage(with: url, placeholder: nil)
            titleLabel.text = category?.name
        }
    }
    
    var index: Int = 0 {
        didSet {
            imageView.image = UIImage.init(named: images[index])
            titleLabel.text = names[index]
        }
    }
    
    
    
    
    
    
    
    
    

}
