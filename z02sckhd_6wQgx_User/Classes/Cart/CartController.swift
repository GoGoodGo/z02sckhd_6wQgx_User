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

public class CartController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var selectedAll: UIButton!
    @IBOutlet weak var barBottom: NSLayoutConstraint!
    
    var cart: Cart?
    var stores = [CartStore]()
    var currentAmount: Float = 0.0
    
    var sectionHeaders = [Int : CartSectionHeader]()
    var sectionFooters = [Int : CartSectionFooter]()
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        self.title = "购物车"
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.sectionFooterHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 60
        tableView.estimatedSectionFooterHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        tableView.register(UINib.init(nibName: CellName(CartGoodsCell.self), bundle: nil), forCellReuseIdentifier: CellName(CartGoodsCell.self))
        tableView.allowsMultipleSelection = true
        
        load()
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(load))
        
        if #available(iOS 11.0, *) {
            barBottom.constant = 0
        } else {
            barBottom.constant = -TabBarH
        }
    }
    
    /** 购物车 */
    @objc func load() {
        showHUD()
        getRequest(baseUrl: Cart_URL, params: ["token" : Singleton.shared.token], success: { [weak self] (obj: CartInfo) in
            self?.hideHUD()
            self?.tableView.mj_header.endRefreshing()
            if "success" == obj.status {
                self?.cart = obj.data
                self?.stores = (obj.data?.goods)!
                self?.tableView.reloadData()
                self?.setupState()
            } else {
                self?.inspect(model: obj)
            }
        }) { (error) in
            self.tableView.mj_header.endRefreshing()
            self.hideHUD()
            self.inspectError()
        }
    }
    /** 更新数量 */
    func loadQuantity(num: Int, label: UILabel, indexPath: IndexPath) {
        showHUD()
        let goods = stores[indexPath.section].result[indexPath.row]
        getRequest(baseUrl: CartQuantity_URL, params: ["token" : Singleton.shared.token, "spec_id" : goods.spec_id, "quantity" : "\(num)"], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                label.text = "\(num)"
                goods.quantity = "\(num)"
            } else {
                self?.inspect(model: obj)
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
        getRequest(baseUrl: CartCheck_URL, params: ["token" : Singleton.shared.token, "rec_id" :  goods.rec_id, "status" : isSelected ? "1" : "0"], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.checkSuccess(isSelected: isSelected, indexPath: indexPath)
            } else {
                if isSelected {
                    self?.tableView.deselectRow(at: indexPath, animated: false)
                } else {
                    self?.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
                self?.inspect(model: obj)
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
        getRequest(baseUrl: CartAllCheck_URL, params: ["token" : Singleton.shared.token, "status" : sender.isSelected ? "1" : "0", "sid" : store.sid], success: { [weak self] (obj: BaseModel) in
            self?.hideAllHUD()
            if "success" == obj.status {
                self?.updateState(section: section, isSelected: sender.isSelected)
            } else {
                sender.isSelected = !sender.isSelected
                self?.inspect(model: obj)
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
        getRequest(baseUrl: CartDelete_URL, params: ["token" : Singleton.shared.token, "rec_id" : goods.rec_id], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.stores[indexPath.section].result.remove(at: indexPath.row)
                if self?.stores[indexPath.section].result.count == 0 {
                    self?.stores.remove(at: indexPath.section)
                }
                self?.tableView.reloadData()
            } else {
                self?.inspect(model: obj)
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
                if goods.is_shipping == "1" {
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    checkSuccess(isSelected: true, indexPath: indexPath)
                }
            }
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
        var give = Int(goods.give_integral)!
        var usable = Int(goods.integral)!
        if give < 0 { give = 0 }
        if usable < 0 { usable = 0 }
        
        if isSelected {
            store.amount += Float(goods.price)! * Float(quantity)!
            store.give += Int(goods.quantity)! * give
            store.usable += Int(quantity)! * usable
        } else {
            store.amount -= Float(goods.price)! * Float(quantity)!
            store.give -= Int(quantity)! * give
            store.usable -= Int(quantity)! * usable
        }
        sectionFooters[indexPath.section]?.title.text = "可获得\(store.give)个积分，可使用\(store.usable)个积分"
        currentAmount = 0
        for s in stores {
            currentAmount += s.amount
        }
        amount.text = String(format: "%.2f", currentAmount)
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
        getRequest(baseUrl: CartSubmit_URL, params: ["token" : Singleton.shared.token], success: { [weak self] (obj: CartOrderInfo) in
            self?.hideHUD()
            if "success" == obj.status {
                let confirmOrder = ConfirmOrderController()
                confirmOrder.orderInfo = obj
                self?.navigationController?.pushViewController(confirmOrder, animated: true)
            } else {
                self?.inspect(model: obj)
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
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
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
        footer.title.text = "可获得\(store.give)个积分，可使用\(store.usable)个积分"
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





