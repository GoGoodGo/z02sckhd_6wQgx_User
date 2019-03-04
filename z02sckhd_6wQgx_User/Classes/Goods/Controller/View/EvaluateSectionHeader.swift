//
//  EvaluateSectionHeader.swift
//  TianMaUser
//
//  Created by YH_O on 2018/7/28.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

enum SectionType {
    case evaluate
    case detial
    case auction
}

class EvaluateSectionHeader: UIView {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var showAll: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var auctionNum: UILabel!
    
    
    var showAllBlock: (() -> Void)?
    
    public class func evaluateHeader() -> Any? {
        
        return bundle(self).loadNibNamed(String(describing: self), owner: nil, options: nil)?.last
    }

    @IBAction func action_showAll() {
        if let click = showAllBlock {
            click()
        }
    }
    
    // MARK: - Setter
    var detial: SalesDetialData? {
        didSet {
            
        }
    }
    
    var number = 0 {
        didSet {
            showAll.setTitle("查看全部(\(number))", for: .normal)
        }
    }
    
    var sectionType: SectionType = .evaluate {
        didSet {
            auctionNum.text = "\(detial?.auctionlog.count ?? 0)人参与竞拍"
            auctionNum.isHidden = sectionType != .auction
            if sectionType == .detial || sectionType == .auction {
                showAll.isHidden = true
                imgView.isHidden = true
                title.text = sectionType == .detial ? "商品详情" : "竞拍记录"
            }
        }
    }
    
    override var frame: CGRect {
        didSet {
            let y: CGFloat = 10
            var tempFrame = frame
            tempFrame.origin.y += y
            tempFrame.size.height -= y
            super.frame = tempFrame
        }
    }

}
