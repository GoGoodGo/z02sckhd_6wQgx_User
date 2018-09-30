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
    var orderResult: MyOrderResult?
    var traces = [Trace]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "查看物流"
        setupUI()
    }

    // MARK: - Private Method
    private func setupUI() {
        
        back.layer.borderColor = HexString("#d3d3d3").cgColor
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 60
        tableView.estimatedSectionFooterHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.register(UINib.init(nibName: CellName(OrderGoodsCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(OrderGoodsCell.self))
        tableView.register(UINib.init(nibName: CellName(LogisticsInfoCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(LogisticsInfoCell.self))
        
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 70, right: 0)
        
        load()
    }
    
    /** 获取物流信息 */
    func load() {
        showHUD()
        let order = orderResult?._orders.first
        getRequest(baseUrl: OrderTraces_URL, params: ["type" : (order?.pack_name ?? ""), "code" : (order?.invoice_no ?? "")], success: { [weak self] (obj: LogisticsInfo) in
            self?.hideHUD()
            if "success" == obj.status && (obj.data?.Success)! {
                self?.traces = (obj.data?.Traces)!.reversed()
                self?.tableView.reloadData()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
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
        return section == 0 ? (orderResult?._orders.first?._goods.count ?? 0) : traces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName(OrderGoodsCell.self)) as! OrderGoodsCell
            cell.orderGoods = orderResult?._orders.first?._goods[indexPath.row]
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName(LogisticsInfoCell.self)) as! LogisticsInfoCell
            cell.index = indexPath.row
            cell.total = traces.count
            cell.trace = traces[indexPath.row]
            
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = LogisticsGoodsHeader.headerView() as! LogisticsGoodsHeader
            header.orderInfo = orderResult?._orders.first
            
            return header
        } else {
            let header = LogisticsHeader.headerView() as! LogisticsHeader
            
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 { return nil }
        let footer = LogisticsGoodsFooter.footerView() as! LogisticsGoodsFooter
        footer.result = orderResult
        
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











