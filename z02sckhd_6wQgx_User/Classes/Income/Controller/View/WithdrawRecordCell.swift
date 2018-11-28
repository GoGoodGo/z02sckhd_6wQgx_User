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
            if withdraw?.status == 0 {
                click(self, withdraw!)
            }
        }
    }
    
    // MARK: - Setter
    var withdraw: Income? {
        didSet {
            name.text = withdraw?.content
            money.text = "¥\(withdraw?.price ?? "0.00")"
            date.text = withdraw?.add_time
            withdrawWay(way: withdraw?.way ?? 0)
            switch withdraw?.status {
            case 0:
                cancel.setTitle("撤销申请", for: .normal)
            case 1:
                cancel.setTitle("审核通过", for: .normal)
            case 2:
                cancel.setTitle("已拒绝", for: .normal)
                cancel.setTitleColor(UIColor.red, for: .normal)
            default: break
            }
        }
    }
    
    func withdrawWay(way: Int) {
        switch way {
        case 1:
            img.image = getImage(type(of: self), "ico_img_zfb")
        case 2:
            img.image = getImage(type(of: self), "ico_img_wx")
        case 3:
            img.image = getImage(type(of: self), "ico_img_yl")
        default:
            break
        }
    }
    
    var way: WithdrawWay = .aliPay {
        didSet {
            switch way {
            case .aliPay:
                img.image = getImage(type(of: self), "ico_img_zfb")
            case .wxPay:
                img.image = getImage(type(of: self), "ico_img_wx")
            case .unionPay:
                img.image = getImage(type(of: self), "ico_img_yl")
            default:
                break
            }
        }
    }
    
    
    
    
    
}
