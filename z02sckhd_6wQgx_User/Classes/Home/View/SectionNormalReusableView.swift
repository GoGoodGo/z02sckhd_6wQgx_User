//
//  SectionNormalReusableView.swift
//  TianMaUser
//
//  Created by Healson on 2018/7/31.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

enum HeaderType {
    case auction
    case group
    case timelimit
    case recommend
    case store
}

class SectionNormalReusableView: UICollectionReusableView {

    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    // MARK: - Setter
    var homeSection: Int = 0 {
        didSet {
            switch homeSection {
            case 1:
                type = .group
            case 2:
                type = .timelimit
            case 3:
                type = .recommend
            case 5:
                type = .store
            default: return
            }
        }
    }
    
    
    var type: HeaderType = .auction {
        didSet {
            var imgName = ""
            switch type {
            case .auction:
                imgName = "ico_img_xspm.png"
            case .group:
                imgName = "ico_img_thtg.png"
            case .timelimit:
                imgName = "ico_img_xlms.png"
            case .recommend:
                imgName = "ico_img_tbtj.png"
            default:
                imgName = "ico_img_jpdp.png"
            }
            imgView.image = UIImage.init(named: imgName)
        }
    }
    
    
    
    
    
    
    
    
    
}
