//
//  ApplyWithdrawController.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/3.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool
import TMSDK

class ApplyWithdrawController: TMViewController {
    
    @IBOutlet weak var avaliableWithdraw: UILabel!
    @IBOutlet weak var totalWithdraw: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var account: UIButton!
    @IBOutlet weak var accountView: UIView!
    
    var accounts = [Account]()
    var accountID = ""
    var completedBlock: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "申请提现"
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        textField.delegate = self
        view.addSubview(pullDownView)
        callbacksPullDown()
        
        load()
        loadAccount()
        loadUserDetial()
    }
    /** 获取用户信息 */
    func loadUserDetial() {
        getRequest(baseUrl: UserDetial_URL, params: ["token" : TMHttpUserInstance.sharedManager().member_code ?? TestToken], success: { [weak self] (obj: UserInfo) in
            if "success" == obj.status {
                self?.avaliableWithdraw.text = "¥\(obj.data?.user_money ?? "0.00")"
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 获取提现收益 */
    func load() {
        getRequest(baseUrl: Income_URL, params: ["token" : TMHttpUserInstance.sharedManager().member_code ?? TestToken, "type" : "2"], success: { [weak self] (obj: IncomeInfo) in
            if "success" == obj.status {
                self?.totalWithdraw.text = "¥\(obj.data?.ok ?? "0.00")"
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 提现账户 */
    func loadAccount() {
        showHUD()
        getRequest(baseUrl: MyAccount_URL, params: ["token" : TMHttpUserInstance.sharedManager().member_code ?? TestToken, "page" : "1"], success: { [weak self] (obj: AccountInfo) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.accounts = (obj.data?.result)!
                self?.setupAccount()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 提现 */
    func loadWithdraw() {
        if Float(textField.text!)! == 0.00 {
            showAutoHideHUD(message: "请输入大于0的金额！")
            return
        }
        showHUD()
        getRequest(baseUrl: ApplyWithdraw_URL, params: ["token" : TMHttpUserInstance.sharedManager().member_code ?? TestToken, "price" : textField.text!, "account_id" : accountID], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.showAutoHideHUD(message: "申请成功，等候处理！", completed: {
                    self?.navigationController?.popViewController(animated: true)
                    if let block = self?.completedBlock {
                        block()
                    }
                })
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
    }
    /** 账户设置 */
    func setupAccount() {
        var names = [String]()
        let defaultAccout = accounts.first
        account.setTitle(defaultAccout?.number, for: .normal)
        accountID = "\(defaultAccout?.id ?? 0)"
        for account in accounts {
            names.append(account.number)
        }
        pullDownView.titles = names
    }
    
    @IBAction func action_option(_ sender: UIButton) {
        view.endEditing(true)
        let point = accountView.convert(CGPoint.init(x: sender.frame.minX, y: sender.frame.maxY), to: view)
        pullDownView.frame = CGRect.init(x: point.x, y: point.y, width: 140, height: 0)
        pullDownView.open()
    }
    
    @IBAction func action_management() {
        let manageAccount = ManageAccountController.init(nibName: "ManageAccountController", bundle: getBundle())
        manageAccount.updateAccount = { [weak self] in
            self?.loadAccount()
        }
        navigationController?.pushViewController(manageAccount, animated: true)
    }
    
    @IBAction func action_sure() {
        loadWithdraw()
    }
    
    private func callbacksPullDown() {
        pullDownView.selectedRowBlock = { [weak self] (title, index) in
            self?.account.setTitle(title, for: .normal)
            let account = self?.accounts[index]
            self?.accountID = "\((account?.id)!)"
        }
    }
    
    // MARK: - Getter
    lazy var pullDownView: YHPullDownView = {
        
        let view = YHPullDownView.init()
        view.frame = CGRect.init(x: 0, y: 0, width: 100, height: 0)
        view.isSelectedCancel = true
        view.titles = []
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.6
        view.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        return view
    }()
}

extension ApplyWithdrawController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = textField.text! + string
        if let money = Float(text) {
            return true
        } else {
            return false
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let money = Float(textField.text!) {
            textField.text = String.init(format: "%.2f", money)
        }
        return true
    }
    
    
}
