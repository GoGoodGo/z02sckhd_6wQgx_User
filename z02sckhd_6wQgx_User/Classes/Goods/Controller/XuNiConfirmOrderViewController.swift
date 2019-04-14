//
//  XuNiConfirmOrderViewController.swift
//  AFNetworking
//
//  Created by 虞淞晴 on 2019/2/27.
//

import UIKit
import YHTool
import TMSDK

class XuNiConfirmOrderViewController: TMViewController {
    
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
        tableView.delegate = self
        tableView.dataSource = self
        //TextFieldTableViewCell
  
        tableView.register(UINib.init(nibName: CellName(OrderGoodsCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(OrderGoodsCell.self))
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: CellName(TextFieldTableViewCell.self))
//        tableView.register(UINib.init(nibName: CellName(TextFieldTableViewCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(TextFieldTableViewCell.self))
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
//        guard let addressID = consignee?.address_id else {
//            showAutoHideHUD(message: "请选择收货地址！")
//            return
//        }
        

        
        var dic = ["token" : TMHttpUserInstance.sharedManager().member_code ?? TestToken, "flow_type" : flowType, "pay_note" : payNote,"grade":"1"] as [String : Any]
        var from_str = ""
        var from_val = ""

        if orderInfo?.data?.from != nil{
            
            for i in 0..<(orderInfo?.data?.from)!.count {
                let model = orderInfo?.data?.from[i]
                from_str.append("\(model!.id)")
                
                from_val.append((self.tableView.cellForRow(at: IndexPath.init(row: i, section: 1)) as! TextFieldTableViewCell).textField.text ?? "")
                
                if (self.tableView.cellForRow(at: IndexPath.init(row: i, section: 1)) as! TextFieldTableViewCell).textField.text == "" {
                    showAutoHideHUD(message: "请输入" + (orderInfo?.data?.from[i].name ?? "")!)
                    return
                }
                
                if i != (orderInfo?.data?.from)!.count-1{
                    from_str.append(",")
                     from_val.append(",")
                }
                

            }
            
            dic["from_str"] = from_str
            dic["from_val"] = from_val

        }
        
        
        
        showHUD()
        
        getRequest(baseUrl: OrderDone_URL, params: dic as! Dictionary<String, String>, success: { [weak self] (obj: OrderInfo) in
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

extension XuNiConfirmOrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSorce
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return (orderInfo?.data?.goods_list?.goods.count)! + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? (orderInfo?.data?.goods_list?.goods[section].result.count)! : (orderInfo?.data?.from.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName(OrderGoodsCell.self)) as! OrderGoodsCell
            cell.cellType = -1
            cell.goods = orderInfo?.data?.goods_list?.goods[indexPath.section].result[indexPath.row]
            
            return cell
        } else {
            let identifier="TextFieldTableViewCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? TextFieldTableViewCell
            if cell == nil {
                cell = TextFieldTableViewCell.init(style: .default, reuseIdentifier: identifier)
            }
            cell?.selectionStyle = .none
            cell?.titleLabel.text = (orderInfo?.data?.from[indexPath.row].name ?? "")!
            cell?.textField.placeholder = "请输入" + (orderInfo?.data?.from[indexPath.row].name ?? "")!
            cell?.closure = {[weak self](tag) in
                print(tag)
            }
            return cell!
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        let header = OrderSectionHeader.header() as! OrderSectionHeader
        let store = orderInfo?.data?.goods_list?.goods[section - 1]
        header.name.text = store?.shopname
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 { return nil }
        let footer = OrderSectionFooter.footer() as! OrderSectionFooter
        footer.payNoteBlock = { [weak self] note in
            self?.payNote = note
        }
        footer.amount = orderInfo?.data?.goods_list?.amount ?? "0.00"
        footer.store = orderInfo?.data?.goods_list?.goods[section]
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 0 ? 0.1 : 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return section == 1 ? 0.1 : tableView.sectionFooterHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.endEditing(true)
    }
    
    
    
    
    
}



