//
//  LogisticsInfoCell.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/7.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class LogisticsInfoCell: UITableViewCell {
    
    @IBOutlet weak var current: UIImageView!
    @IBOutlet weak var previous: UIImageView!
    @IBOutlet weak var top: UIImageView!
    @IBOutlet weak var bottom: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var address: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    // MARK: - Setter
    var trace: Trace? {
        didSet {
            date.text = trace?.AcceptTime
            address.text = trace?.AcceptStation
        }
    }
    
    var total: Int = 0 {
        didSet {
            bottom.isHidden = index == total - 1 ? true : false
            if total == 1 {
                bottom.isHidden = true
                current.isHidden = true
                previous.isHidden = true
                top.isHidden = true
            }
        }
    }
    
    var index: Int = 0 {
        didSet {
            current.isHidden = index == 0 ? false : true
            previous.isHidden = index == 0 ? true : false
            top.isHidden = index == 0 ? true : false
        }
    }
    
    
    
}
