//
//  MyOrderController.swift
//  TianMaUser
//
//  Created by YH_O on 2018/8/6.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import MJRefresh
import YHTool
import TMSDK

class MyOrderController: TMViewController {
    
    @IBOutlet weak var segmentContent: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let titles = ["待付款", "待发货", "待收货", "待评价", "已完成"]
    
    var sectionHeaders = [Int : OrderHeaderView]()
    var sectionFooters = [Int : OrderFooterView]()
    var orderInfo: MyOrderData?
    var notEvaluates = [NotEvaluateGoods]()
    var status = "11"
    var evaluateStatus = ""
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的订单"
        setupUI()
    }
    
    // MARK: - PrivateMethod
    private func setupUI() {
        
        segmentContent.addSubview(segmentView)
        segmentCallbacks()
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 60
        tableView.estimatedSectionFooterHeight = 50
        tableView.register(UINib.init(nibName: CellName(MyOrderCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(MyOrderCell.self))
        tableView.register(UINib.init(nibName: CellName(NotEvaluateCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(NotEvaluateCell.self))
        
        load()
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(load))
    }
    /** 我的订单 */
    @objc func load() {
        showHUD()
        getRequest(baseUrl: MyOrder_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "order_status" : status, "status" : evaluateStatus], success: { [weak self] (obj: MyOrderInfo) in
            self?.hideHUD()
            self?.tableView.mj_header.endRefreshing()
            if "success" == obj.status {
                self?.orderInfo = obj.data
                self?.getHeight()
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
    /** 待评价商品 */
    func loadEvaluateGoods() {
        showHUD()
        getRequest(baseUrl: NotEvaluate_URL, params: ["token" : TMHttpUser.token() ?? TestToken], success: { [weak self] (obj: NotEvaluateInfo) in
            self?.hideHUD()
            self?.tableView.mj_header.endRefreshing()
            if "success" == obj.status {
                self?.notEvaluates = (obj.data?.result)!
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
    /** 立即付款 */
    func loadPay(section: Int) {
        
        let onlinePay = OnlinePayController.init(nibName: "OnlinePayController", bundle: getBundle())
        onlinePay.mid = "\((orderInfo?.result[section].mid)!)"
        onlinePay.orderSN = (orderInfo?.result[section].order_sn)!
        onlinePay.amount = (orderInfo?.result[section].order_amount)!
        navigationController?.pushViewController(onlinePay, animated: true)
    }
    /** 确认收货 */
    func loadReceive(section: Int) {
        showHUD()
        getRequest(baseUrl: OrderReceive_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "order_id" : "\((orderInfo?.result[section]._orders.first?.order_id)!)"], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.orderInfo?.result.remove(at: section)
                self?.tableView.reloadData()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
    }
    /** 取消订单 */
    func loadCancel(section: Int) {
        showHUD()
        getRequest(baseUrl: OrderCancel_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "mid" : "\((orderInfo?.result[section].mid)!)"], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.orderInfo?.result.remove(at: section)
                self?.tableView.reloadData()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
    }
    /** 计算高度 */
    func getHeight() {
        if let results = orderInfo?.result {
            for result in results {
                let sections = result._orders.count
                var rows = 0
                var allRowsH: CGFloat = 0.00
                for order in result._orders {
                    rows += order._goods.count
                    for goods in order._goods {
                        let replySize = goods.returninfo?.reply.textSize(font: UIFont.systemFont(ofSize: 12), maxSize: CGSize.init(width: WIDTH - WidthPercent(100), height: HEIGHT))
                        let reasonSize = goods.returninfo?.desc.textSize(font: UIFont.systemFont(ofSize: 12), maxSize: CGSize.init(width: WIDTH - WidthPercent(100), height: HEIGHT))
                        allRowsH = HeightPercent(180) + (replySize?.height ?? 0.00) + (reasonSize?.height ?? 0.00)
                    }
                }
                result.total = "\(rows)"
                result.cellHeight = CGFloat(sections) * 40 + CGFloat(rows) * HeightPercent(120)
                result.detialCellHeight = CGFloat(sections) * 40 + allRowsH
            }
        }
    }
    /** 订单详情 */
    private func orderDetial(section: Int) {
        let orderDetial = OrderDetialController.init(nibName: "OrderDetialController", bundle: getBundle())
        orderDetial.cellType = currentIndex
        orderDetial.orderResult = orderInfo?.result[section]
        navigationController?.pushViewController(orderDetial, animated: true)
    }
    /** 退换货 */
    private func returnChangeGoods(seciton: Int, indexPath: IndexPath, returnBtn: UIButton) {
        let returnChange = ReturnChangeController.init(nibName: "ReturnChangeController", bundle: getBundle())
        returnChange.orderResult = orderInfo?.result[seciton]
        returnChange.subIndexPath = indexPath
        returnChange.returnBtn = returnBtn
        navigationController?.pushViewController(returnChange, animated: true)
    }
    /** 立即评价 */
    private func evaluateGoods(section: Int, indexPath: IndexPath, evaluateBtn: UIButton) {
        let evaluateCtrl = EvaluateController.init(nibName: "EvaluateController", bundle: getBundle())
        evaluateCtrl.evaluateBtn = evaluateBtn
        evaluateCtrl.evaluate = orderInfo?.result[section]._orders[indexPath.section]._goods[indexPath.row]
        navigationController?.pushViewController(evaluateCtrl, animated: true)
    }
    
    // MARK: - Callbacks
    private func callbacks(sectionHeader: OrderHeaderView) {
        sectionHeader.touchBlock = { [weak self] header in
            self?.orderDetial(section: sectionHeader.section)
        }
    }
    
    private func callbacks(sectionFooter: OrderFooterView) {
        sectionFooter.payBlock = { [weak self] (sender, footer) in
            switch self?.currentIndex {
            case 0: // 立即付款
                self?.loadPay(section: footer.section)
            case 2: // 确认收货
                self?.alertViewCtrl(message: "是否确认收货？", sureHandler: { (action) in
                    self?.loadReceive(section: footer.section)
                }, cancelHandler: nil)
            default: return
            }
        }
        sectionFooter.returnBlock = { [weak self] (sender, footer) in
            switch self?.currentIndex {
            case 0:
                self?.alertViewCtrl(message: "确认取消订单？", sureHandler: { (action) in
                    self?.loadCancel(section: footer.section)
                }, cancelHandler: nil)
            case 2: // 查看物流
                let logisticsCtrl = LogisticsController.init(nibName: "LogisticsController", bundle: getBundle())
                let result = self?.orderInfo?.result[footer.section]
                logisticsCtrl.orderResult = result
                self?.navigationController?.pushViewController(logisticsCtrl, animated: true)
            default: return
            }
        }
        sectionFooter.cancelBlock = { [weak self] (sender, footer) in
            self?.orderDetial(section: footer.section)
        }
        sectionFooter.touchBlock = { [weak self] footer in
            self?.orderDetial(section: sectionFooter.section)
        }
    }
    
    private func segmentCallbacks() {
        segmentView.clickItemBlock = { [weak self] (index) in
            self?.currentIndex = index
            self?.evaluateStatus = ""
            switch index {
            case 0:
                self?.status = "11"
            case 1:
                self?.status = "20"
            case 2:
                self?.status = "30"
            case 3:
                self?.status = "40"
                self?.evaluateStatus = "1"
            case 4:
                self?.status = "40"
            default: break
            }
            self?.load()
        }
    }
    
    // MARK: - Getter
    private lazy var segmentView: YHSegmentView = {
        
        let view = YHSegmentView.init(frame: CGRect.init(x: 0, y: 0, width: WIDTH, height: 50), titles: self.titles)
        view.normalColor = HexString("#666666")
        view.selectedColor = HexString("#ff5863")
        view.indicatorColor = HexString("#ff5863")
        view.indicatorW = 50
        return view
    }()
}

extension MyOrderController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSorce
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderInfo?.result.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellName(MyOrderCell.self)) as! MyOrderCell
        cell.cellType = currentIndex
        cell.orders = (orderInfo?.result[indexPath.section]._orders)!
        cell.returnBlock = { [weak self] (cell, subIndexPath) in
            if self?.currentIndex == 3 {
                self?.evaluateGoods(section: indexPath.section, indexPath: subIndexPath, evaluateBtn: cell.returnGoods)
            } else {
                self?.returnChangeGoods(seciton: indexPath.section, indexPath: subIndexPath, returnBtn: cell.returnGoods)
            }
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let header = OrderHeaderView.headerView() as! OrderHeaderView
        header.result = orderInfo?.result[section]
        header.section = section
        callbacks(sectionHeader: header)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let footer = OrderFooterView.footerView() as! OrderFooterView
        footer.state = currentIndex
        footer.result = orderInfo?.result[section]
        footer.section = section
        callbacks(sectionFooter: footer)
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return tableView.sectionFooterHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (orderInfo?.result[indexPath.section].cellHeight ?? 0)
    }
    
    
    
    
    
}








