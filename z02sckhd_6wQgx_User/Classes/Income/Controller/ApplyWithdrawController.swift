//
//  ApplyWithdrawController.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/3.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool

class ApplyWithdrawController: UIViewController {
    
    @IBOutlet weak var avaliableWithdraw: UILabel!
    @IBOutlet weak var totalWithdraw: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var account: UIButton!
    @IBOutlet weak var accountView: UIView!
    
    var withdrawData: IncomeData?
    var accounts = [Account]()
    var accountID = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "申请提现"
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        view.addSubview(pullDownView)
        callbacksPullDown()
        avaliableWithdraw.text = "¥\(withdrawData?.money ?? "0.00")"
        totalWithdraw.text = "¥\(withdrawData?.ok ?? 0.00)"
        
        load()
    }
    /** 提现账户 */
    @objc func load() {
        showHUD()
        getRequest(baseUrl: MyAccount_URL, params: ["token" : Singleton.shared.token, "page" : "1"], success: { [weak self] (obj: AccountInfo) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.accounts = (obj.data?.result)!
                self?.setupAccount()
            } else {
                self?.inspect(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 提现 */
    func loadWithdraw() {
        showHUD()
        getRequest(baseUrl: ApplyWithdraw_URL, params: ["token" : Singleton.shared.token, "price" : textField.text!, "account_id" : accountID], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.showAutoHideHUD(message: "申请成功，等候处理！", completed: {
                    self?.navigationController?.popViewController(animated: true)
                })
            } else {
                self?.inspect(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
    }
    /** 账户设置 */
    func setupAccount() {
        var names = [String]()
        for account in accounts {
            names.append(account.number)
        }
        pullDownView.titles = names
    }
    
    @IBAction func action_option(_ sender: UIButton) {
        let point = accountView.convert(CGPoint.init(x: sender.frame.minX, y: sender.frame.maxY), to: view)
        pullDownView.frame = CGRect.init(x: point.x, y: point.y, width: 140, height: 0)
        pullDownView.open()
    }
    
    @IBAction func action_management() {
        let manageAccount = ManageAccountController.init(nibName: "ManageAccountController", bundle: getBundle())
        navigationController?.pushViewController(manageAccount, animated: true)
    }
    
    @IBAction func action_sure() {
        loadWithdraw()
    }
    
    private func callbacksPullDown() {
        pullDownView.selectedRowBlock = { [weak self] (title, index) in
            self?.account.setTitle(title, for: .normal)
            let account = self?.accounts[index]
            self?.accountID = (account?.id)!
        }
    }
    
    // MARK: - Getter
    lazy var pullDownView: YHPullDownView = {
        
        let view = YHPullDownView.init()
        view.frame = CGRect.init(x: 0, y: 0, width: 100, height: 0)
        view.isSelectedCancel = true
        view.titles = ["支付宝", "微信"]
        return view
    }()
    
    
    
    

}
