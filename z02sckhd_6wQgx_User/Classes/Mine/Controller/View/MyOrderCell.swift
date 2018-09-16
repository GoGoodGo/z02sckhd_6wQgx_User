//
//  MyOrderCell.swift
//  TianMaUser
//
//  Created by YH_O on 2018/8/27.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool

class MyOrderCell: UITableViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    var cellType = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - PrivateMethod
    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: CellName(OrderGoodsCell.self), bundle: bundle(type(of: self))), forCellReuseIdentifier: CellName(OrderGoodsCell.self))
    }
    
    // MARK: - Setter
    var orders = [MyOrder]() {
        didSet {
            tableView.reloadData()
        }
    }
}

extension MyOrderCell: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSorce
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders[section]._goods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellName(OrderGoodsCell.self)) as! OrderGoodsCell
        cell.orderGoods = orders[indexPath.section]._goods[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = MyOrderHeader.headerView() as! MyOrderHeader
        header.type = cellType
        header.order = orders[section]
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HeightPercent(120)
    }
    
    
    
    
    
    
    
    
    
}












