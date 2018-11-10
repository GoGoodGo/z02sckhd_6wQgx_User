//
//  AddressCell.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/6.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {
    
    @IBOutlet weak var defaultImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var address: UILabel!
    
    var addressSet: ((_ tag: Int, _ cell: AddressCell) -> Void)?
    
    let btnTag = 777
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func updateDefaultAnimail(isDefault: Bool) {
        let alpha: CGFloat = isDefault ? 1 : 0
        UIView.animate(withDuration: 0.3) {
            self.defaultImg.alpha = alpha
        }
    }
    
    // MARK: - Callbacks
    @IBAction func action_addressSet(_ sender: UIButton) {
        
        let tag = sender.tag - btnTag
        if let click = addressSet {
            click(tag, self)
        }
    }
    
    // MARK: - Setter
    var addressModel: Address? {
        didSet {
            name.text = addressModel?.consignee
            phone.text = addressModel?.tel
            address.text = addressModel?.address
//            updateDefaultAnimail(isDefault: (addressModel?.is_default)! == "1" ? true : false)
            updateDefaultAnimail(isDefault: addressModel?.is_default ?? false)
        }
    }
    
    override var frame: CGRect {
        didSet {
            let y: CGFloat = 10
            var tempFrame = frame
            tempFrame.origin.y += y
            super.frame = tempFrame
        }
    }
    
    
    
    
    
    
}
