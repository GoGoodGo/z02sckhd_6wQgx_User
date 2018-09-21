//
//  MemberCell.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/3.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    // MARK: - Setter
    var member: Member? {
        didSet {
            let url = URL.init(string: (member?.head_pic)!)
            img.kf.setImage(with: url)
            name.text = member?.member_name
            date.text = member?.add_time
        }
    }
    override var frame: CGRect {
        didSet {
            let y: CGFloat = 10
            var tempFrame = frame
            tempFrame.origin.y += y
            tempFrame.size.height -= 1
            super.frame = tempFrame
        }
    }
    
    
}
