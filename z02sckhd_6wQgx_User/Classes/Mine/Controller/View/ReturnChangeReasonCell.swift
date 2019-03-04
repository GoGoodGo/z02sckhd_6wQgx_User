//
//  ReturnChangeReasonCell.swift
//  z02sckhd_6wQgx_User
//
//  Created by Healson on 2018/9/28.
//

import UIKit

class ReturnChangeReasonCell: UITableViewCell {
    
    @IBOutlet weak var reason: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        reason.isSelected = selected
    }
    
    // MARK: - Setter
    var reasonMsg = "" {
        didSet {
            reason.setTitle(reasonMsg, for: .normal)
        }
    }
    
    
    
    
    
    
    
    
    
}
