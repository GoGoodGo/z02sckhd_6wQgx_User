//
//  StarRatingCell.swift
//  TianMaUser
//
//  Created by YH_O on 2018/8/7.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import Cosmos
import YHTool

class StarRatingCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var starView: UIView!
    
    let titles = ["商品质量", "服务态度", "物流配送"]
    var touchRating: ((_ rating: Double, _ cell: StarRatingCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        setupUI()
    }
    
    // MARK: - PrivateMethod
    private func setupUI() {
        
        let cosmos = CosmosView.init(frame: CGRect.init(x: 0, y: 0, width: starView.frame.size.width, height: starView.frame.size.height))
        cosmos.rating = 5
        cosmos.settings.fillMode = .full
        cosmos.settings.starSize = 20
        cosmos.settings.starMargin = 10
        cosmos.settings.filledColor = HexString("#ff5863")
        cosmos.settings.emptyBorderColor = HexString("#666666")
        cosmos.didFinishTouchingCosmos = { [weak self] rating in
            if let touch = self?.touchRating {
                touch(rating, self!)
            }
        }
        
        starView.addSubview(cosmos)
    }
    
    // MARK: - Setter
    var index: Int = 0 {
        didSet {
            title.text = titles[index]
        }
    }
    
    override var frame: CGRect {
        didSet {
            let y:CGFloat = 10
            var tempFrame = frame
            tempFrame.origin.y += y
            super.frame = tempFrame
        }
    }
    
    
}




