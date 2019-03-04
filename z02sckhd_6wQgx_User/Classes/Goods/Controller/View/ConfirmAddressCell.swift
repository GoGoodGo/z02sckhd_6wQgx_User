//
//  ConfirmAddressCell.swift
//  TianMaUser
//
//  Created by Healson on 2018/7/31.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class ConfirmAddressCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var address: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    
        
    }
    
    // MARK: - Setter
    var addressModel: Address? {
        didSet {
            name.text = addressModel?.consignee
            phone.text = addressModel?.tel
            address.text = (addressModel?.address ?? "") + (addressModel?.address_name ?? "")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
