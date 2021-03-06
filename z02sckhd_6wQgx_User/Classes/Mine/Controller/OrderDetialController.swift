//
//  OrderDetialController.swift
//  TianMaUser
//
//  Created by YH_O on 2018/8/11.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import MJRefresh
import YHTool
import TMSDK

class OrderDetialController: TMViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var orderResult: MyOrderResult?
    var goodsCellH: CGFloat = 0
    var replyCellH: CGFloat = 0
    var goodsTotal = "0"
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
        goodsCellH = orderResult?.cellHeight ?? 0.00
        replyCellH = orderResult?.detialCellHeight ?? 0.00
        goodsTotal = orderResult?.total ?? "0"
        load()
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(load))
    }
    /** 订单详情 */
    @objc func load() {
        showHUD()
        getRequest(baseUrl: OrderDetial_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "mid" : "\((orderResult?.mid)!)"], success: { [weak self] (obj: OrderDetial) in
            self?.hideHUD()
            self?.tableView.mj_header.endRefreshing()
            if "success" == obj.status {
                self?.orderResult = obj.data
                self?.orderResult?.total = (self?.goodsTotal)!
                self?.tableView.reloadData()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.tableView.mj_header.endRefreshing()
            self.inspectError()
        }
    }
    
    /** 退换货 */
    private func returnChangeGoods(seciton: Int, indexPath: IndexPath, returnBtn: UIButton) {
        let returnChange = ReturnChangeController.init(nibName: "ReturnChangeController", bundle: getBundle())
        returnChange.orderResult = orderResult
        returnChange.subIndexPath = indexPath
        returnChange.returnBtn = returnBtn
        navigationController?.pushViewController(returnChange, animated: true)
    }
    /** 立即评价 */
    private func evaluateGoods(section: Int, indexPath: IndexPath, evaluateBtn: UIButton) {
        let evaluateCtrl = EvaluateController.init(nibName: "EvaluateController", bundle: getBundle())
        evaluateCtrl.evaluateBtn = evaluateBtn
        evaluateCtrl.evaluate = orderResult?._orders[indexPath.section]._goods[indexPath.row]
        navigationController?.pushViewController(evaluateCtrl, animated: true)
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
            cell.returnBlock = { [weak self] (cell, subIndexPath) in
                if self?.cellType == 3 {
                    self?.evaluateGoods(section: indexPath.section, indexPath: subIndexPath, evaluateBtn: cell.returnGoods)
                } else {
                    self?.returnChangeGoods(seciton: indexPath.section, indexPath: subIndexPath, returnBtn: cell.returnGoods)
                }
            }
            
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
            return goodsCellH
        } else if indexPath.section == 1 {
            return 50
        } else {
            return replyCellH
        }
    }
    
    
    
    
}






