//
//  GoodsParameterCell.swift
//  TianMaUser
//
//  Created by YH_O on 2018/7/28.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool

class GoodsParameterCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - PrivateMethod
    private func setupUI() {
        
        
    }
    
    override var isSelected: Bool {
        didSet {
            title.isSelected = isSelected
            title.backgroundColor = isSelected ? HexString("#ff5863") : HexString("#f5f5f5")
        }
    }
    
    
}
