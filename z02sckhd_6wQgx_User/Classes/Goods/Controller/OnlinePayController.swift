//
//  OnlinePayController.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/1.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool
import TMSDK
import TMShare

public let PayNotificationName = "payNotificationName"

class OnlinePayController: TMViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var mid = "01"
    var orderSN = "00000001"
    var amount = "0.00"
    var currentDate = "0"
    var payWay = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title =  "在线支付"
        
        NotificationCenter.default.addObserver(self, selector: #selector(payResult(notification:)), name: NSNotification.Name(rawValue: PayNotificationName), object: nil)
        
        setupUI()
    }
    
    // MARK: - Callbacks
    private func callbacks(cell: OnlinePayWayCell) {
        cell.pay = { [weak self] type in
            self?.payWay = type
            self?.loadPay(type: type)
        }
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.register(UINib.init(nibName: CellName(OnlinePayOrderInfoCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(OnlinePayOrderInfoCell.self))
        tableView.register(UINib.init(nibName: CellName(OnlinePayWayCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(OnlinePayWayCell.self))
    }
    /** 订单支付 */
    func loadPay(type: String) {
        showHUD()
        if payWay == "1" {
            getRequest(baseUrl: OrderPay_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "mid" : mid, "type" : type, "form" : "1"], success: { [weak self] (obj: PayInfo) in
                self?.hideHUD()
                if "success" == obj.status {
                    AlipaySDK.defaultService().payOrder(obj.data, fromScheme: "TianMa_User") { [weak self] (result) in
                        self?.disposeResult(payResult: result!)
                    }
                } else {
                    self?.inspectLogin(model: obj)
                }
            }) { (error) in
                self.inspectError()
            }
        } else {
            getRequest(baseUrl: OrderPay_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "mid" : mid, "type" : type, "form" : "1"], success: { [weak self] (obj: WxPayInfo) in
                self?.hideHUD()
                if "success" == obj.status {
                    self?.wechatPay(pay: obj)
                } else {
                    self?.inspectLogin(model: obj)
                }
            }) { (error) in
                self.inspectError()
            }
        }
    }
    
    // MARK: - WxPay
    private func wechatPay(pay: WxPayInfo) {
//        let request = PayReq()
//        request.partnerId = pay.data?.partnerid
//        request.prepayId = pay.data?.prepayid
//        request.package = pay.data?.package
//        request.nonceStr = pay.data?.noncestr
//        request.timeStamp = (pay.data?.timestamp)!
//        request.sign = pay.data?.sign
        
//        if !WXApi.isWXAppInstalled() {
//            showAutoHideHUD(message: "还未安装微信, 换支付宝试试？")
//            return
//        } else if !WXApi.isWXAppSupport() {
//            showAutoHideHUD(message: "该微信版本不支持支付, 换支付宝试试！")
//            return
//        }
//        WXApi.send(request)
    }
    
    // MARK: - Pay Notification
    @objc private func payResult(notification: Notification) {
        if payWay == "0" {
            disposeResult(payResult: notification.userInfo!)
        } else {
            disposeWxPayResult(payResult: notification.userInfo!)
        }
    }
    
    /** 支付宝支付结果处理 */
    func disposeResult(payResult: Dictionary<AnyHashable, Any>) {
        let resultStatus = payResult["resultStatus"] as! String
        if Int(resultStatus) == 9000 {
            paySuccess()
        } else if Int(resultStatus) == 8000 {
            showAutoHideHUD(message: "处理中...")
        } else if Int(resultStatus) == 4000 {
            showAutoHideHUD(message: "订单支付失败！")
        } else if Int(resultStatus) == 6001 {
            showAutoHideHUD(message: "您已取消支付!")
        } else if Int(resultStatus) == 6002 {
            showAutoHideHUD(message: "网络连接错误！")
        }
    }
    
    /** 微信支付结果处理 */
    private func disposeWxPayResult(payResult: Dictionary<AnyHashable, Any>) {
        let code = payResult["errorCode"] as! String
        switch code {
        case "0":
            paySuccess()
        default:
            showAutoHideHUD(message: "微信支付失败！")
            break
        }
    }
    
    /** 支付成功 */
    func paySuccess() {
        let paySuccess = PaySuccessController.init(nibName: "PaySuccessController", bundle: getBundle())
        navigationController?.pushViewController(paySuccess, animated: true)
    }
}

extension OnlinePayController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName(OnlinePayOrderInfoCell.self)) as! OnlinePayOrderInfoCell
            cell.orderID.text = "订单编号：\(orderSN)"
            if currentDate == "0" {
                cell.date.text = "创建时间：\(Date.currentDateStr())"
            } else {
                cell.date.text = "创建时间：\(Date.dateWithSeconds(totalSeconds: Double(currentDate)!))"
            }
            cell.amount.text = "¥\(amount)"
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName(OnlinePayWayCell.self)) as! OnlinePayWayCell
            callbacks(cell: cell)
            
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    
    
    
    
}











