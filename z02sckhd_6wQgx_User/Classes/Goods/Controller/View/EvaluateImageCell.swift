//
//  EvaluateImageCell.swift
//  TianMaUser
//
//  Created by YH_O on 2018/7/28.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import Kingfisher

class EvaluateImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    var getImages: ((_ image: UIImage?) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - Setter
    var commentImage: CommentImage? {
        didSet {
            let url = URL(string: (commentImage?.path)!)
            imgView.kf.setImage(with: url) { [weak self] (image, error, type, url) in
                if let block = self?.getImages {
                    block(image)
                }
            }
            
        }
    }

    
    
}
