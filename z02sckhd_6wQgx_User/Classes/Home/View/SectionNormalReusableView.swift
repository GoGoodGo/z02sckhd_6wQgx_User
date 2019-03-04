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
                headerType = .group
            case 2:
                headerType = .timelimit
            case 3:
                headerType = .recommend
            case 5:
                headerType = .store
            default: return
            }
        }
    }
    
    var headerType: HeaderType = .auction {
        didSet {
            var imgName = ""
            switch headerType {
            case .auction:
                imgName = "ico_img_xspm"
            case .group:
                imgName = "ico_img_thtg"
            case .timelimit:
                imgName = "ico_img_xlms"
            case .recommend:
                imgName = "ico_img_tbtj"
            default:
                imgName = "ico_img_jpdp"
            }
            imgView.image = getImage(type(of: self), imgName)
        }
    }
    
    
    
    
    
    
    
    
    
}
