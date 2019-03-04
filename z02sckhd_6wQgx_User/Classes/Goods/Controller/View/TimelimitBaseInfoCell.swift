//
//  TimelimitBaseInfoCell.swift
//  TianMaUser
//
//  Created by Healson on 2018/7/27.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class TimelimitBaseInfoCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var describe: UILabel!
    @IBOutlet weak var boughtNum: UILabel!
    @IBOutlet weak var remainingNum: UILabel!
    @IBOutlet weak var priceType: UILabel!
    @IBOutlet weak var discountPrice: UILabel!
    @IBOutlet weak var originalPrice: UILabel!
    @IBOutlet weak var days: UILabel!
    @IBOutlet weak var hours: UIButton!
    @IBOutlet weak var minutes: UIButton!
    @IBOutlet weak var seconds: UIButton!
    
    var timer: Timer?
    var type: DetialType = .groupBuy

    override func awakeFromNib() {
        super.awakeFromNib()
    
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(action_timer), userInfo: nil, repeats: true)
        timer?.fireDate = Date.distantFuture
        
        let loop = RunLoop.current
        loop.add(timer!, forMode: RunLoop.Mode.common)
        
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
    }
    
    // MARK: - Callbacks
    @objc private func action_timer() {
        
        let currentTime = Int(Date().timeIntervalSince1970)
        let endTime = Date.timestampFromString(dateStr: (result?.store?.end_time ?? "2018-09-06 20:00:00"), format: "yyyy-MM-dd HH:mm:ss")
        let time = Int(endTime)! - currentTime
        if time >= 0 {
            let dateComp = Date.dateFromTimestamp(timestamp: "\(time)")
            let allHours = time / 60 / 60
            days.text = "\(allHours / 24)天"
            hours.setTitle("\(allHours % 24)", for: .normal)
            minutes.setTitle("\(dateComp.minute ?? 00)", for: .normal)
            seconds.setTitle("\(dateComp.second ?? 00)", for: .normal)
        }
    }
    
    // MARK: - Setter
    var result: SalesDetialData? {
        didSet {
            timer?.fireDate = Date.distantPast
            
            name.text = result?.goods?.goods_name
            describe.text = (result?.goods?.defaultspec?.spec_1 ?? "") + (result?.goods?.defaultspec?.spec_2 ?? "")
            switch type {
            case .groupBuy:
                remainingNum.text = ""
                boughtNum.text = "剩余数量：\(result?.store?.num ?? 0)件"
                priceType.text = "团购价"
                discountPrice.text = "¥\(result?.store?.price ?? "0.00")"
            case .timelimit:
                boughtNum.text = "秒杀数量：\(result?.store?.num ?? 0)件"
                remainingNum.text = "剩余数量：\(result?.store?.total ?? 0)件"
                priceType.text = "秒杀价"
                discountPrice.text = "¥\(result?.store?.price ?? "0.00")"
            default: break
            }
            originalPrice.attributedText = "¥ \(result?.goods?.price ?? "0.00")".addStrikethrough()
        }
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    
    
    
    
}
