//
//  WithdrawAccountCell.swift
//  TianMaUser
//
//  Created by YH_O on 2018/8/3.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class WithdrawAccountCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var defaultImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nameY: NSLayoutConstraint!
    
    let btnTag = 333
    var accountTypes = ["ico_img_zfb.png", "ico_img_wx.png", "ico_img_yl.png"]
    var accountSetBlock: ((_ cell: WithdrawAccountCell, _ tag: Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setDefaultAnimail(isDefault: selected)
    }
    
    public func setDefaultAnimail(isDefault: Bool) {
        let alpha: CGFloat = isDefault ? 1 : 0
        let y: CGFloat = isDefault ? 10 : 0
        UIView.animate(withDuration: 0.3, animations: {
            self.defaultImg.alpha = alpha
            self.nameY.constant = y
            self.layoutIfNeeded()
        })
    }
    
    // MARK: - Callbacks
    @IBAction func action_accountSet(_ sender: UIButton) {
        let tag = sender.tag - btnTag
        if let click = accountSetBlock {
            click(self, tag)
        }
    }
    
    // MARK: - Setter
    var account: Account? {
        didSet {
            name.text = account?.number
//            setDefaultAnimail(isDefault: account?.is_default == "1" ? true : false)
            let type = account?.type
            img.image = UIImage.init(named: accountTypes[Int(type!)! - 1])
        }
    }
    
    
    
    
}
