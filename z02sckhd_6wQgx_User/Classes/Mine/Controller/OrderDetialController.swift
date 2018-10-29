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
    var cellType = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "订单详情"
        setupUI()
    }
    
    // MARK: - PrivateMethod
    private func setupUI() {
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 60
        tableView.estimatedSectionFooterHeight = 50
        tableView.register(UINib.init(nibName: CellName(MyOrderCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(MyOrderCell.self))
        tableView.register(UINib.init(nibName: CellName(OrderDetialInfoCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(OrderDetialInfoCell.self))
        tableView.register(UINib.init(nibName: CellName(ReturnChangeDetialOrderCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(ReturnChangeDetialOrderCell.self))
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 20, right: 0)
        
        load()
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
            self.hideHUD()
            self.inspectError()
        }
    }
}

extension OrderDetialController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSorce
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return cellType == 4 ? 3 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 7
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName(MyOrderCell.self)) as! MyOrderCell
            cell.cellType = cellType
            cell.orders = (orderResult?._orders)!
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName(OrderDetialInfoCell.self)) as! OrderDetialInfoCell
            cell.result = orderResult
            cell.index = indexPath.row
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName(ReturnChangeDetialOrderCell.self)) as! ReturnChangeDetialOrderCell
            cell.cellType = cellType
            cell.orders = (orderResult?._orders)!
            
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = OrderHeaderView.headerView() as! OrderHeaderView
            header.result = orderResult
            
            return header
        } else {
            let header = OrderDetialHeader.headerView() as! OrderDetialHeader
            header.section = section
            
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let footer = OrderDetialFooter.footerView() as! OrderDetialFooter
            footer.result = orderResult
            
            return footer
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return tableView.sectionFooterHeight
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return orderResult?.cellHeight ?? 0
        } else if indexPath.section == 1 {
            return 50
        } else {
            return orderResult?.detialCellHeight ?? 0
        }
    }
    
    
    
    
}






