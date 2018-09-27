//
//  AuctionBaseInfoCell.swift
//  TianMaUser
//
//  Created by Healson on 2018/7/27.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool

class AuctionBaseInfoCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var describe: UILabel!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var startPrice: UILabel!
    @IBOutlet weak var increasePrice: UILabel!
    @IBOutlet weak var originalPrice: UILabel!
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var remaining: UILabel!
    @IBOutlet weak var end: UIButton!
    @IBOutlet weak var timelimit: UIView!
    @IBOutlet weak var days: UILabel!
    @IBOutlet weak var hours: UIButton!
    @IBOutlet weak var minutes: UIButton!
    @IBOutlet weak var seconds: UIButton!
    
    var timer: Timer?
    var clickItemBlock: ((_ cell: AuctionBaseInfoCell, _ index: Int) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(action_timer), userInfo: nil, repeats: true)
        timer?.fireDate = Date.distantFuture
        
        let loop = RunLoop.current
        loop.add(timer!, forMode: .commonModes)
        
        setupUI()
    }
    
    // MARK: - PrivateMethod
    private func setupUI() {
        
        layout.itemSize = CGSize.init(width: 70, height: 20)
        
        collectionView.register(UINib.init(nibName: CellName(GoodsParameterCell.self), bundle: getBundle()), forCellWithReuseIdentifier: CellName(GoodsParameterCell.self))
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Callbacks
    @objc private func action_timer() {
        
        let currentTime = Int(Date().timeIntervalSince1970)
        let endTime = Date.timestampFromString(dateStr: (result?.store?.end_time ?? "2018-09-06 01:01:01"), format: "yyyy-MM-dd HH:mm:ss")
        var time = Int(endTime)! - currentTime
        if time > 0 {
            let dateComp = Date.dateFromTimestamp(timestamp: "\(time)")
            let allHours = time / 60 / 60
            days.text = "\(allHours / 24)天"
            hours.setTitle("\(allHours % 24)", for: .normal)
            minutes.setTitle("\(dateComp.minute ?? 00)", for: .normal)
            seconds.setTitle("\(dateComp.second ?? 00)", for: .normal)
            
        }
        if (result?.store?.is_end ?? false) || time <= 0 {
            time = 0
            timer?.fireDate = Date.distantFuture
        }
        end.isHidden = time > 0
        timelimit.isHidden = time <= 0
        remaining.isHidden = time <= 0
    }
    
    // MARK: - Setter
    var result: SalesDetialData? {
        didSet {
            timer?.fireDate = Date.distantPast
            name.text = result?.goods?.goods_name
            describe.text = (result?.goods?.defaultspec?.spec_1 ?? "") + (result?.goods?.defaultspec?.spec_2 ?? "")
            
            startPrice.text = "起拍价：¥\(result?.store?.price ?? "0.00")"
            increasePrice.text = "加价：¥\(result?.store?.markups ?? "0.00")"
            originalPrice.text = "原价：¥\(result?.store?.maxprice ?? "0.00")"
            currentPrice.text = "¥\(result?.store?.new_price ?? "0.00")"
            
            collectionView.reloadData()
        }
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
}

extension AuctionBaseInfoCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return result?.goods?._specs_all.count ?? 0
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName(GoodsParameterCell.self), for: indexPath) as! GoodsParameterCell
        let spec = result?.goods?._specs_all[indexPath.row]
        cell.title.setTitle((spec?.spec_1 ?? "") + (spec?.spec_2 ?? ""), for: .normal)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let click = clickItemBlock {
            click(self, indexPath.row)
        }
    }
    
    
    
    
}








