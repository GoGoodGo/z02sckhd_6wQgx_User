//
//  ReturnChangeController.swift
//  z02sckhd_6wQgx_User
//
//  Created by Healson on 2018/9/28.
//

import UIKit
import YHTool

class ReturnChangeController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var orderResult: MyOrderResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "退换货"
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 60
        tableView.estimatedSectionFooterHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.register(UINib.init(nibName: CellName(OrderGoodsCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(OrderGoodsCell.self))
        tableView.register(UINib.init(nibName: CellName(ReturnChangeCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(ReturnChangeCell.self))
        
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 70, right: 0)
    }
    
    @IBAction func action_apply(_ sender: UIButton) {
        
        
    }
    
}

extension ReturnChangeController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSorce
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? (orderResult?._orders.first?._goods.count ?? 0) : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName(OrderGoodsCell.self)) as! OrderGoodsCell
            cell.orderGoods = orderResult?._orders.first?._goods[indexPath.row]
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName(ReturnChangeCell.self)) as! ReturnChangeCell
            
            
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 { return nil }
        let header = LogisticsGoodsHeader.headerView() as! LogisticsGoodsHeader
        header.orderInfo = orderResult?._orders.first
        
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 { return nil }
        let footer = LogisticsGoodsFooter.footerView() as! LogisticsGoodsFooter
        footer.result = orderResult
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 1 ? 10 : tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return tableView.sectionFooterHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
}









