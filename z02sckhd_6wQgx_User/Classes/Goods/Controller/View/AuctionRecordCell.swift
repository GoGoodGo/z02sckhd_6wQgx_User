//
//  AuctionRecordCell.swift
//  TianMaUser
//
//  Created by YH_O on 2018/7/28.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class AuctionRecordCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var increase: UILabel!
    @IBOutlet weak var auctionPrice: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    // MARK: - Setter
    var log: AuctionLog? {
        didSet {
            name.text = (log?.tel ?? "***")
            date.text = Date.dateWithSeconds(totalSeconds: Double(log?.bid_time ?? "0")!, formatter: "yyyy-MM-dd HH:mm:ss")
            increase.text = "0.00"
            auctionPrice.text = "¥\(log?.bid_price ?? "0.00")"
        }
    }
    
    
    
    
    
    
    
    
}
