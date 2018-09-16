//
//  CollectStoreCell.swift
//  TianMaUser
//
//  Created by YH_O on 2018/8/11.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool
import Kingfisher

class CollectStoreCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var sales: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var cancel: UIButton!
    
    var cancelBlock: ((_ cell: CollectStoreCell) -> Void)?

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
            let url = URL.init(string: (collect?.banner)!)
            img.kf.setImage(with: url, placeholder: nil)
            name.text = collect?.shopname
        }
    }
    
    

}
