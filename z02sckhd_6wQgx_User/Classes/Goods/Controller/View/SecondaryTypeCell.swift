//
//  SecondaryTypeCell.swift
//  TianMaUser
//
//  Created by Healson on 2018/7/30.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool
import Kingfisher

class SecondaryTypeCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 2
        
    }
    
    // MARK: - Setter
    var category: CategoryInfo? {
        didSet {
            let url = URL.init(string: (category?.image ?? ""))
            imgView.kf.setImage(with: url, placeholder: nil)
            name.text = category?.name
        }
    }
    
    override var isSelected: Bool {
        didSet {
            
            self.backgroundColor = isSelected ? HexString("#ff5863") : HexString("#f3f4f8")
            name.textColor = isSelected ? UIColor.white : HexString("#9fa5bb")
//            imgView.image = isSelected ? getImage(type(of: self), "ico_img_mz1xz") : getImage(type(of: self), "ico_img_mz1")
        }
    }
    
    
    
    
    
    
    
    

}
