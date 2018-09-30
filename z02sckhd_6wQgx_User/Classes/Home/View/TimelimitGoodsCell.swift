//
//  TimelimitGoodsCell.swift
//  TianMaUser
//
//  Created by Healson on 2018/7/26.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import Kingfisher

class TimelimitGoodsCell: UICollectionViewCell {
    
    @IBOutlet weak var totalBtn: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var describe: UILabel!
    @IBOutlet weak var priceType: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var days: UILabel!
    @IBOutlet weak var hours: UIButton!
    @IBOutlet weak var minutes: UIButton!
    @IBOutlet weak var seconds: UIButton!
    
    var timer: Timer?
    var type: DetialType = .detial
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(action_timer), userInfo: nil, repeats: true)
        timer?.fireDate = Date.distantFuture
        
        let loop = RunLoop.current
        loop.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    // MARK: - Callbacks
    @objc private func action_timer() {
        
        let currentTime = Int(Date().timeIntervalSince1970)
//        let endTime = Date.timestampFromString(dateStr: (result?.end_time ?? "2018-09-06 20:00:00"), format: "yyyy-MM-dd HH:mm:ss")
        let time = Int(result?.end_time ?? "\(currentTime)")! - currentTime
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
    var result: SalesResult? {
        didSet {
            timer?.fireDate = Date.distantPast
            
            let url = URL(string: (result?.default_image ?? ""))
            imgView.kf.setImage(with: url)
            name.text = result?.goods_name
            describe.text = result?.spec_name
            switch type {
            case .auction:
                totalBtn.setTitle("\(result?.number ?? "1")人竞拍", for: .normal)
                priceType.text = "竞拍价"
            case .groupBuy:
                totalBtn.setTitle("\(result?.number ?? "1")人参团", for: .normal)
                priceType.text = "团购价"
            case .timelimit:
                totalBtn.setTitle("\(result?.number ?? "1")人秒杀", for: .normal)
                priceType.text = "秒杀价"
            default: break
            }
            price.text = result?.price
        }
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    
    
    
    
    

}
