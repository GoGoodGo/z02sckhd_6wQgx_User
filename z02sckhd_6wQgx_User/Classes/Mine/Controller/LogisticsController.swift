//
//  LogisticsController.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/7.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool

class LogisticsController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var back: UIButton!
    
    var sectionHeaders = [Int : UIView]()
    var sectionFooters = [Int : LogisticsGoodsFooter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "查看物流"
        setupUI()
    }

    // MARK: - Private Method
    private func setupUI() {
        
        back.layer.borderColor = HexString("#d3d3d3").cgColor
        
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.sectionFooterHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 60
        tableView.estimatedSectionFooterHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        tableView.register(UINib.init(nibName: CellName(OrderGoodsCell.self), bundle: bundle(type(of: self))), forCellReuseIdentifier: CellName(OrderGoodsCell.self))
        tableView.register(UINib.init(nibName: CellName(LogisticsInfoCell.self), bundle: bundle(type(of: self))), forCellReuseIdentifier: CellName(LogisticsInfoCell.self))
        
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 70, right: 0)
    }
    
    @IBAction func action_backOrder() {
        navigationController?.popViewController(animated: true)
    }
    

}

extension LogisticsController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSorce
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName(OrderGoodsCell.self)) as! OrderGoodsCell
            
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName(LogisticsInfoCell.self)) as! LogisticsInfoCell
            cell.index = indexPath.row
            cell.total = 3
            
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = sectionHeaders[section] {
            
            return header
        }
        if section == 0 {
            let header = LogisticsGoodsHeader.headerView() as! LogisticsGoodsHeader
            sectionHeaders[section] = header
            
            return header
        } else {
            let header = LogisticsHeader.headerView() as! LogisticsHeader
            sectionHeaders[section] = header
            
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 { return nil }
        if let footer = sectionFooters[section] {
            
            return footer
        }
        let footer = LogisticsGoodsFooter.footerView() as! LogisticsGoodsFooter
        sectionFooters[section] = footer
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return tableView.sectionFooterHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    
    
    
    
}











