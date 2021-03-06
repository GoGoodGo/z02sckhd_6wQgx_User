//
//  ManageAccountController.swift
//  TianMaUser
//
//  Created by YH_O on 2018/8/3.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import MJRefresh
import YHTool
import TMSDK

class ManageAccountController: TMViewController {
    
    @IBOutlet weak var option: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var accountTypeView: UIView!
    
    var accountType = "" // 账户类型
    var types = ["支付宝", "微信", "银联"]
    var accountData: AccountData?
    var tag = 0 // 操作类型
    var currentID = ""
    var isUpdate = false
    var updateAccount: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "提现账户"
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isUpdate {
            if let update = updateAccount {
                update()
            }
        }
    }
    
    // MARK: - PrivateMethod
    private func setupUI() {
        
        tableView.register(UINib.init(nibName: CellName(WithdrawAccountCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(WithdrawAccountCell.self))
        header.addSubview(pullDownView)
        callbacksPullDown()
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(load))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        load()
    }
    /** 提现账户 */
    @objc func load() {
        showHUD()
        getRequest(baseUrl: MyAccount_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "page" : "1"], success: { [weak self] (obj: AccountInfo) in
            self?.hideHUD()
            self?.tableView.mj_header.endRefreshing()
            if "success" == obj.status {
                self?.accountData = obj.data
                obj.data?.page += 1
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
    /** 加载更多 */
    @objc func loadMore() {
        getRequest(baseUrl: MyAccount_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "page" : "\(accountData?.page ?? 1)"], success: { [weak self] (obj: AccountInfo) in
            self?.tableView.mj_footer.endRefreshing()
            if "success" == obj.status {
                self?.accountData?.result += (obj.data?.result)!
                obj.data?.page += 1
                self?.tableView.reloadData()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.tableView.mj_footer.endRefreshing()
            self.inspectError()
        }
    }
    /** 新增账户 */
    func loadAdd(number: String) {
        showHUD()
        getRequest(baseUrl: AddAccount_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "type" : accountType, "number" : number, "is_default" : "1"], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.load()
                self?.isUpdate = true
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
    }
    /** 编辑账户 */
    func loadEdit(number: String) {
        showHUD()
        getRequest(baseUrl: EditAccount_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "type" : accountType, "number" : number, "id" : currentID], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.load()
                self?.isUpdate = true
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
    }
    /** 删除账户 */
    func loadDel(index: Int) {
        showHUD()
        getRequest(baseUrl: DelAccount_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "id" : currentID], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.accountData?.result.remove(at: index)
                self?.tableView.reloadData()
                self?.isUpdate = true
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
    }
    /** 设置默认账户 */
    func setDefaultAccount(indexPath: IndexPath?) {
        showHUD()
        getRequest(baseUrl: SetDefaultAccount_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "id" : currentID], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                self?.isUpdate = true
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
    }
    
    // MARK: - Check Footer
    func checkFooterState() {
        if let data = accountData {
            tableView.mj_footer.isHidden = (data.result.count == 0)
            if data.page >= data.totalpage {
                tableView.mj_footer.endRefreshingWithNoMoreData()
            } else {
                tableView.mj_footer.endRefreshing()
            }
        } else {
            tableView.mj_footer.isHidden = true
        }
    }
    
    // MARK: - Callbacks
    @IBAction func action_option(_ sender: UIButton) {
        let point = accountTypeView.convert(CGPoint.init(x: sender.frame.minX, y: sender.frame.maxY), to: header)
        pullDownView.frame = CGRect.init(x: point.x, y: point.y, width: 140, height: 0)
        pullDownView.open()
    }
    
    @IBAction func action_sure(_ sender: UIButton) {
        if tag == 1 {
            loadEdit(number: textField.text!)
        } else {
            if accountType.isEmpty {
                showAutoHideHUD(message: "请选择账户类型！")
                return
            }
            if (textField.text?.isEmpty)! {
                showAutoHideHUD(message: "请输入账户名称!")
                return
            }
            loadAdd(number: textField.text!)
        }
    }
    
    private func callbacksPullDown() {
        pullDownView.selectedRowBlock = { [weak self] (title, index) in
            self?.option.setTitle(title, for: .normal)
            self?.accountType = "\(index + 1)"
        }
    }
    
    private func callbacks(cell: WithdrawAccountCell) {
        cell.accountSetBlock = { [weak self] (cell, tag) in
            let indexPath = self?.tableView.indexPath(for: cell)
            self?.tag = tag
            let account = self?.accountData?.result[(indexPath?.row)!]
            self?.currentID = "\((account?.id)!)"
            
            switch tag {
            case 0: // 设置默认
                self?.setDefaultAccount(indexPath: indexPath)
            case 1:
                self?.accountType = "\((account?.type)!)"
                self?.option.setTitle(self?.types[(account?.type)! - 1], for: .normal)
                self?.textField.text = account?.number
                self?.tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            case 2:
                self?.alertViewCtrl(message: "确认删除地址？", sureHandler: { (action) in
                    self?.loadDel(index: (indexPath?.row)!)
                }, cancelHandler: nil)
            default: return
            }
        }
    }
    
    // MARK: - Getter
    lazy var pullDownView: YHPullDownView = {
        
        let view = YHPullDownView.init()
        view.frame = CGRect.init(x: 0, y: 0, width: 100, height: 0)
        view.isSelectedCancel = true
        view.titles = types
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.6
        view.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        return view
    }()

}

extension ManageAccountController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkFooterState()
        return accountData?.result.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellName(WithdrawAccountCell.self)) as! WithdrawAccountCell
        callbacks(cell: cell)
        let account = accountData?.result[indexPath.row]
        cell.account = account
        if account?.is_default ?? false {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = WithdrawSectionHeader.sectionHeader() as! WithdrawSectionHeader
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    
    
    
    
}









