//
//  WithdrawRecordCell.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/3.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

enum WithdrawWay {
    case aliPay
    case wxPay
    case unionPay
}

class WithdrawRecordCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var cancel: UIButton!
    
    var cancelBlock: ((_ cell: WithdrawRecordCell, _ withdraw: Income) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    // MARK: - Callbacks
    @IBAction func action_cancel(_ sender: UIButton) {
        if let click = cancelBlock {
            click(self, withdraw!)
        }
    }
    
    // MARK: - Setter
    var withdraw: Income? {
        didSet {
            name.text = withdraw?.content
            money.text = "¥\(withdraw?.price ?? "0.00")"
            date.text = withdraw?.add_time
            withdrawWay(way: (withdraw?.way)!)
        }
    }
    
    func withdrawWay(way: String) {
        switch way {
        case "0":
            img.image = UIImage.init(named: "ico_img_zfb.png")
        case "1":
            img.image = UIImage.init(named: "ico_img_wx.png")
        case "2":
            img.image = UIImage.init(named: "ico_img_yl.png")
        default:
            break
        }
    }
    
    var way: WithdrawWay = .aliPay {
        didSet {
            switch way {
            case .aliPay:
                img.image = UIImage.init(named: "ico_img_zfb.png")
            case .wxPay:
                img.image = UIImage.init(named: "ico_img_wx.png")
            case .unionPay:
                img.image = UIImage.init(named: "ico_img_yl.png")
            default: break
            }
        }
    }
    
    
    
    
    
}
