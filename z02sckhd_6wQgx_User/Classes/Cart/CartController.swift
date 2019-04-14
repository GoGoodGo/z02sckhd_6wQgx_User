//
//  CartController.swift
//  TianMaUser
//
//  Created by YH_O on 2018/7/24.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import MJRefresh
import YHTool
import TMSDK
import RongIMKit

public class CartController: TMViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var selectedAll: UIButton!
    @IBOutlet weak var barBottom: NSLayoutConstraint!
    
    var cart: Cart?
    var stores = [CartStore]()
    var currentAmount: Float = 0.0
    
    var sectionHeaders = [Int : CartSectionHeader]()
    var sectionFooters = [Int : CartSectionFooter]()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "购物车"
        setupUI()

    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if inspectLogin() == true{
            tableView.mj_header.beginRefreshing()
        }

    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 60
        tableView.estimatedSectionFooterHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.register(UINib.init(nibName: CellName(CartGoodsCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(CartGoodsCell.self))
        tableView.allowsMultipleSelection = true
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(load))
        if #available(iOS 11.0, *) {
            barBottom.constant = 0
        } else {
            barBottom.constant = -TabBarH
        }
//        load()
//        showHUD()
    }
    
    /** 购物车 */
    @objc func load() {
        getRequest(baseUrl: Cart_URL, params: ["token" : TMHttpUserInstance.sharedManager().member_code ?? TestToken], success: { [weak self] (obj: CartInfo) in
            self?.hideAllHUD()
            self?.tableView.mj_header.endRefreshing()
            if "success" == obj.status {
                self?.cart = obj.data
                self?.stores = (obj.data?.goods)!
                self?.tableView.reloadData()
                self?.setupState()
            }
//            else {
//                self?.inspectLogin(model: obj)
//            }
        }) { (error) in
            self.tableView.mj_header.endRefreshing()
            self.hideAllHUD()
            self.inspectError()
        }
    }
    /** 更新数量 */
    func loadQuantity(num: Int, label: UILabel, indexPath: IndexPath) {
        showHUD()
        let goods = stores[indexPath.section].result[indexPath.row]
        let store = stores[indexPath.section]
        getRequest(baseUrl: CartQuantity_URL, params: ["token" : TMHttpUserInstance.sharedManager().member_code ?? TestToken, "spec_id" : "\(goods.spec_id)", "quantity" : "\(num)"], success: { [weak self] (obj: CartInfo) in
            self?.hideHUD()
            if "success" == obj.status {
                if goods.is_shipping != 0 {
                    store.amount += Float(num - goods.quantity) * Float(goods.price)!
                }
                label.text = "\(num)"
                goods.quantity = num
                if let amount = obj.data?.amount {
                    self?.amount.text = amount
                }
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
    }
    /** 单选 */
    func loadCheck(indexPath: IndexPath, isSelected: Bool) {
        showHUD()
        let goods = stores[indexPath.section].result[indexPath.row]
        getRequest(baseUrl: CartCheck_URL, params: ["token" : TMHttpUserInstance.sharedManager().member_code ?? TestToken, "rec_id" : "\(goods.rec_id)", "status" : isSelected ? "1" : "0"], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                goods.is_shipping = isSelected ? 1 : 0
                self?.checkSuccess(isSelected: isSelected, indexPath: indexPath)
            } else {
                if isSelected {
                    self?.tableView.deselectRow(at: indexPath, animated: false)
                } else {
                    self?.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
    }
    /** section 全选 */
    func loadAllCheck(section: Int, sender: UIButton) {
        showHUD()
        let store = stores[section]
        getRequest(baseUrl: CartAllCheck_URL, params: ["token" : TMHttpUserInstance.sharedManager().member_code ?? TestToken, "status" : sender.isSelected ? "1" : "0", "sid" : "\(store.sid)"], success: { [weak self] (obj: BaseModel) in
            self?.hideAllHUD()
            if "success" == obj.status {
                self?.updateState(section: section, isSelected: sender.isSelected)
            } else {
                sender.isSelected = !sender.isSelected
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideAllHUD()
            self.inspectError()
        }
    }
    
    /** 删除商品 */
    func loadDelete(indexPath: IndexPath) {
        showHUD()
        let goods = stores[indexPath.section].result[indexPath.row]
        getRequest(baseUrl: CartDelete_URL, params: ["token" : TMHttpUserInstance.sharedManager().member_code ?? TestToken, "rec_id" : "\(goods.rec_id)"], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.stores[indexPath.section].result.remove(at: indexPath.row)
                if self?.stores[indexPath.section].result.count == 0 {
                    self?.stores.remove(at: indexPath.section)
                }
                self?.tableView.reloadData()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
    }
    /** 单选成功 */
    func checkSuccess(isSelected: Bool, indexPath: IndexPath) {
        updateAmount(isSelected: isSelected, indexPath: indexPath)
        let indexPaths = tableView.indexPathsForSelectedRows
        var flag = 0
        
        if let paths = indexPaths {
            for item in paths {
                if item.section == indexPath.section {
                    flag += 1
                }
            }
        }
        stores[indexPath.section].isSelected = flag == stores[indexPath.section].result.count ? true : false
        sectionHeaders[indexPath.section]?.isSelected = stores[indexPath.section].isSelected
        
        updateSelectedAllState()
    }
    /** 初始化状态 */
    func setupState() {
        for (section, store) in stores.enumerated() {
            for (row, goods) in store.result.enumerated() {
                let indexPath = IndexPath.init(row: row, section: section)
                if goods.is_shipping != 0 {
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    checkSuccess(isSelected: true, indexPath: indexPath)
                }
            }
        }
        if stores.count == 0 {
            isSelectedAll = false
            currentAmount = 0.00
            amount.text = "\(currentAmount)"
        }
    }
    /** 更新 section 的状态 */
    private func updateState(section: Int, isSelected: Bool) {
        stores[section].isSelected = isSelected
        tableView.reloadSections(IndexSet.init(integer: section), with: .none)
        if isSelected {
            stores[section].amount = 0.0
            stores[section].give = 0
            stores[section].usable = 0
        }
        for (row, _) in stores[section].result.enumerated() {
            let indexPath = IndexPath.init(row: row, section: section)
            updateAmount(isSelected: isSelected, indexPath: indexPath)
            if isSelected {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            } else {
                tableView.deselectRow(at: indexPath, animated: false)
            }
        }
        updateSelectedAllState()
    }
    /** 更新总价 */
    func updateAmount(isSelected: Bool, indexPath: IndexPath) {
        let goods = stores[indexPath.section].result[indexPath.row]
        let store = stores[indexPath.section]
        
        let quantity = goods.quantity
        var give = goods.give_integral
        var usable = goods.integral
        if give < 0 { give = 0 }
        if usable < 0 { usable = 0 }
        
        if isSelected {
            store.amount += Float(goods.price)! * Float(quantity)
            store.give += quantity * give
            store.usable += quantity * usable
        } else {
            store.amount -= Float(goods.price)! * Float(quantity)
            store.give -= quantity * give
            store.usable -= quantity * usable
        }
//        sectionFooters[indexPath.section]?.title.text = "可获得\(store.give)个积分，可使用\(store.usable)个积分"
        sectionFooters[indexPath.section]?.title.text = ""
        
        currentAmount = 0.00
        for s in stores {
            currentAmount += s.amount
        }
        amount.text = String(format: "%.2f", fabsf(currentAmount))
    }
    
    /** 更新选中所有按钮状态 */
    private func updateSelectedAllState() {
        let selectedCount = tableView.indexPathsForSelectedRows?.count
        var totalNum = 0
        for store in stores {
            totalNum += store.result.count
        }
        isSelectedAll = selectedCount == totalNum ? true : false
    }
    
    // MARK: - Callbacks
    @IBAction func action_selectedAll(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        for (key, value) in sectionHeaders {
            if sender.isSelected != value.title.isSelected {
                value.title.isSelected = sender.isSelected
                loadAllCheck(section: key, sender: value.title)
            }
        }
    }
    
    @IBAction func pay() {
        showHUD()
        getRequest(baseUrl: CartSubmit_URL, params: ["token" : TMHttpUserInstance.sharedManager().member_code ?? TestToken], success: { [weak self] (obj: CartOrderInfo) in
            self?.hideHUD()
            if "success" == obj.status {
                let confirmOrder = ConfirmOrderController.init(nibName: "ConfirmOrderController", bundle: getBundle())
                confirmOrder.orderInfo = obj
                self?.navigationController?.pushViewController(confirmOrder, animated: true)
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    
    func callbacks(sectionHeader: CartSectionHeader) {
        sectionHeader.selectedStore = { [weak self] (sender, header) in
            self?.loadAllCheck(section: header.section, sender: sender)
            if sender.isSelected {
                self?.updateSelectedAllState()
            }
        }
    }
    
    func callbacks(cell: CartGoodsCell) {
        cell.updateNum = { [weak self] (cell, num) in
            let indexPath = self?.tableView.indexPath(for: cell)
            self?.loadQuantity(num: num, label: cell.number, indexPath: indexPath!)
        }
    }
    
    // MARK: - Setter
    var isSelectedAll: Bool = false {
        didSet {
            selectedAll.isSelected = isSelectedAll
        }
    }
}

extension CartController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSorce
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        return stores.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores[section].result.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellName(CartGoodsCell.self)) as! CartGoodsCell
        callbacks(cell: cell)
        cell.goods = stores[indexPath.section].result[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        load()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        loadCheck(indexPath: indexPath, isSelected: true)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        loadCheck(indexPath: indexPath, isSelected: false)
    }

    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction.init(style: .default, title: "删除") { (action, indexPath) in
            self.alertViewCtrl(title: "提示", message: "是否删除此商品？", sureHandler: { (action) in
                self.loadDelete(indexPath: indexPath)
            }, cancelHandler: nil)
        }
        return [deleteAction];
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let store = stores[section]
        let header = CartSectionHeader.sectionHeader() as! CartSectionHeader
        header.isSelected = store.isSelected
        header.title.setTitle(store.shopname, for: .normal)
        header.section = section
        callbacks(sectionHeader: header)
        sectionHeaders[section] = header
        
        return header
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let store = stores[section]
        let footer = CartSectionFooter.sectionFooter() as! CartSectionFooter
//        footer.title.text = "可获得\(store.give)个积分，可使用\(store.usable)个积分"
        footer.title.text = ""
        sectionFooters[section] = footer
        
        return footer
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return tableView.sectionHeaderHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return tableView.sectionFooterHeight
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    
    
    
    
    
}





