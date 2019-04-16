//
//  ConfirmOrderController.swift
//  TianMaUser
//
//  Created by Healson on 2018/7/31.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool
import TMSDK

class ConfirmOrderController: TMViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var footer: UIView!
    @IBOutlet weak var integralInfo: UILabel!
    
    var orderInfo: CartOrderInfo?
    var consignee: Address?
    var flowType = ""
    var payNote = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isTranslucent = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "确认订单"
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 50
        tableView.estimatedSectionFooterHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.register(UINib.init(nibName: CellName(ConfirmAddressCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(ConfirmAddressCell.self))
        tableView.register(UINib.init(nibName: CellName(OrderGoodsCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(OrderGoodsCell.self))
        tableView.allowsMultipleSelection = true
        
        getConsignee()
        totalPrice.text = "¥\(orderInfo?.data?.order_amount ?? "0.00")"
        integralInfo.text = "可获得\(orderInfo?.data?.total?.give_integral ?? 0)积分, 可使用\(orderInfo?.data?.total?.integral ?? 0)积分"
        updateQuantity()
    }
    
    @IBAction func action_close() {
        UIView.animate(withDuration: 0.4, animations: {
            self.footer.alpha = 0
        }) { (completion) in
            self.footer.frame.size.height = 10
            self.tableView.reloadData()
        }
    }
    /** 获取默认收件人 */
    func getConsignee() {
        if let defaultAddress = orderInfo?.data?.consignee_default {
            for address in defaultAddress {
                if address.is_default == "1" {
                    consignee = address
                    return
                }
            }
            consignee = defaultAddress.first
        }
    }
    
    @IBAction func action_submitOrder(_ sender: UIButton) {
        guard let addressID = consignee?.address_id else {
            showAutoHideHUD(message: "请选择收货地址！")
            return
        }
        showHUD()
        getRequest(baseUrl: OrderDone_URL, params: ["token" : "\(TMHttpUserInstance.sharedManager().member_id)", "flow_type" : flowType, "address_id" : "\(addressID)", "pay_note" : payNote,"grade":"0"], success: { [weak self] (obj: OrderInfo) in
            self?.hideHUD()
            if "success" == obj.status {
                let onlinePay = OnlinePayController.init(nibName: "OnlinePayController", bundle: getBundle())
                onlinePay.mid = (obj.data?.order_id)!
                onlinePay.orderSN = (obj.data?.order_sn)!
                onlinePay.amount = "\(self?.orderInfo?.data?.order_amount ?? "0.00")"
                self?.navigationController?.pushViewController(onlinePay, animated: true)
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    
    /** 商品数量及总价 */
    func updateQuantity() {
        guard let stores = orderInfo?.data?.goods_list?.goods else { return }
        for store in stores {
            var quantity = 0
            var price: Float = 0.0
            for goods in store.result {
                quantity += goods.quantity
                price += Float(goods.quantity) * Float(goods.price)!
            }
            store.totalQuantity = "\(quantity)"
            store.amount = price + (Float(store.pay_fee) ?? 0.00)
        }
    }
}

extension ConfirmOrderController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSorce
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return (orderInfo?.data?.goods_list?.goods.count)! + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : (orderInfo?.data?.goods_list?.goods[section - 1].result.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName(ConfirmAddressCell.self)) as! ConfirmAddressCell
            cell.addressModel = consignee
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName(OrderGoodsCell.self)) as! OrderGoodsCell
            cell.cellType = -1
            cell.goods = orderInfo?.data?.goods_list?.goods[indexPath.section - 1].result[indexPath.row]
            
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let address = AddressController.init(nibName: "AddressController", bundle: getBundle())
            address.selectedAddress = { [weak self] (model, index) in
                self?.consignee = model
                tableView.reloadData()
            }
            navigationController?.pushViewController(address, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        let header = OrderSectionHeader.header() as! OrderSectionHeader
        let store = orderInfo?.data?.goods_list?.goods[section - 1]
        header.name.text = store?.shopname
        
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        let footer = OrderSectionFooter.footer() as! OrderSectionFooter
        footer.payNoteBlock = { [weak self] note in
            self?.payNote = note
        }
        footer.amount = orderInfo?.data?.goods_list?.amount ?? "0.00"
        footer.store = orderInfo?.data?.goods_list?.goods[section - 1]
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return section == 0 ? 0.1 : tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        return section == 0 ? 0.1 : tableView.sectionFooterHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.endEditing(true)
    }
    
    
    
    
    
}



