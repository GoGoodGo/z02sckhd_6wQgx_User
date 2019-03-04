//
//  MyIncomeCell.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/3.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class MyIncomeCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var income: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    // MARK: - Setter
    var incomeData: Income? {
        didSet {
            name.text = incomeData?.content
            income.text = (incomeData?.sign ?? "+") + (incomeData?.price ?? "0.00")
            date.text = incomeData?.add_time
        }
    }
    
}
