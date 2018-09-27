//
//  OrderDetialController.swift
//  TianMaUser
//
//  Created by YH_O on 2018/8/11.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool
import TMSDK

class OrderDetialController: TMViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var orderResult: MyOrderResult?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "订单详情"
        setupUI()
    }
    
    // MARK: - PrivateMethod
    private func setupUI() {
        
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.sectionFooterHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 60
        tableView.estimatedSectionFooterHeight = 50
        tableView.register(UINib.init(nibName: CellName(MyOrderCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(MyOrderCell.self))
        tableView.register(UINib.init(nibName: CellName(OrderDetialInfoCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(OrderDetialInfoCell.self))
    }
    /** 订单详情 */
    func load() {
        showHUD()
        getRequest(baseUrl: OrderDetial_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "mid" : (orderResult?.mid)!], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.tableView.reloadData()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
}

extension OrderDetialController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSorce
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName(MyOrderCell.self)) as! MyOrderCell
            cell.orders = (orderResult?._orders)!
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName(OrderDetialInfoCell.self)) as! OrderDetialInfoCell
            cell.result = orderResult
            cell.index = indexPath.row
            
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 { return nil }
        let header = OrderHeaderView.headerView() as! OrderHeaderView
        header.result = orderResult
        
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 { return nil }
        let footer = OrderDetialFooter.footerView() as! OrderDetialFooter
        footer.result = orderResult
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 { return 0 }
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return tableView.sectionFooterHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? orderResult?.cellHeight ?? 0 : 50
    }
    
    
    
    
}






