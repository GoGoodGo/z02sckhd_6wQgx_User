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
import TMPaySDK
import Alamofire
import SwiftyJSON

public let PayNotificationName = "payNotificationName"

class OnlinePayController: TMViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var mid = "01"
    var orderSN = "00000001"
    var amount = "0.00"
    var currentDate = "0"
    var payWay = "1"
    var platforms = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title =  "在线支付"
        
        NotificationCenter.default.addObserver(self, selector: #selector(payResult(notification:)), name: NSNotification.Name(rawValue: PayNotificationName), object: nil)
        
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.register(UINib.init(nibName: CellName(OnlinePayOrderInfoCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(OnlinePayOrderInfoCell.self))
        tableView.register(UINib.init(nibName: CellName(OnlinePayWayCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(OnlinePayWayCell.self))
        
        TMPayUtils.sharedInstance().tm_getPayPlatform { [weak self] (platforms, errorInfo) in
            self?.platforms = platforms as! [Int]
        }
    }
    
    // MARK: - Callbacks
    private func callbacks(cell: OnlinePayWayCell) {
        cell.pay = { [weak self] type in
            self?.payWay = type
            if (self?.platforms.contains(Int(type)!))! {
                self?.loadPay(type: type)
            } else {
                self?.showAutoHideHUD(message: "未安装微信，换支付宝试试？")
            }
        }
    }
    
    /** 订单支付 */
    func loadPay(type: String) {
        showHUD()
        if payWay == "1" {
            getRequest(baseUrl: OrderPay_URL, params: ["token" : TMHttpUserInstance.sharedManager().member_code ?? TestToken, "mid" : mid, "type" : type, "form" : "1"], success: { [weak self] (obj: PayInfo) in
                self?.hideHUD()
                if "success" == obj.status {
                    TMPayUtils.sharedInstance().tm_pay(withOrderData: obj.data, type: .aliPay, payFinish: { (status, data, message) in
                        self?.disposeTMPayResult(status: status, message: message)
                    })
                } else {
                    self?.inspectLogin(model: obj)
                }
            }) { (error) in
                self.inspectError()
            }
        } else {
            Alamofire.request(OrderPay_URL, method: .get, parameters: ["token" : TMHttpUserInstance.sharedManager().member_code ?? TestToken, "mid" : mid, "type" : type, "form" : "1"]).responseJSON { [weak self] (response) in
                self?.hideHUD()
                guard response.result.isSuccess else {
                    self?.inspectError()
                    return
                }
                if let value = response.result.value {
                    let json = JSON(value)
                    let status = json["status"].stringValue
                    if "success" == status {
                        let wxPayDict = json["data"].dictionaryObject
                        TMPayUtils.sharedInstance().tm_pay(withOrderData: wxPayDict, type: .weChat, payFinish: { (status, data, message) in
                            self?.disposeTMPayResult(status: status, message: message)
                        })
                    } else {
                        self?.showAutoHideHUD(message: json["msg"].stringValue)
                    }
                }
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
        if payWay == "1" {
            disposeResult(payResult: notification.userInfo!)
        } else {
            disposeWxPayResult(payResult: notification.userInfo!)
        }
    }
    /** TM 支付结果处理 */
    private func disposeTMPayResult(status: TMPayStatus, message: String?) {
        switch status {
        case .success:
            paySuccess()
        case .fail:
            showAutoHideHUD(message: "订单支付失败！")
        case .noKnow:
            showAutoHideHUD(message: message ?? "未知错误！")
        default: break
        }
    }
    
    /** 支付宝支付结果处理 */
    func disposeResult(payResult: Dictionary<AnyHashable, Any>) {
        let resultStatus = payResult["resultStatus"] as! String
        if resultStatus == "9000" {
            paySuccess()
        } else if resultStatus == "8000" {
            showAutoHideHUD(message: "处理中...")
        } else if resultStatus == "4000" {
            showAutoHideHUD(message: "订单支付失败！")
        } else if resultStatus == "6001" {
            showAutoHideHUD(message: "您已取消支付!")
        } else if resultStatus == "6002" {
            showAutoHideHUD(message: "网络连接错误！")
        } else {
            showAutoHideHUD(message: "返回结果有错误！")
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











