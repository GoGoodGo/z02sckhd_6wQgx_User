//
//  WithdrawRecordController.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/3.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import MJRefresh
import YHTool
import TMSDK

class WithdrawRecordController: TMViewController {
    
    @IBOutlet weak var unverify: UILabel!
    @IBOutlet weak var verify: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var withdrawData: IncomeData?
    var withdraws = [Income]()
    var status = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "提现记录"
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.item(title: "申请提现", titleColor: HexString("#3363ff"), target: self, action: #selector(action_withdraw))
        
        tableView.register(UINib.init(nibName: CellName(WithdrawRecordCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(WithdrawRecordCell.self))
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(load))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        load()
    }
    
    /** 获取收益 */
    @objc func load() {
        showHUD()
        getRequest(baseUrl: Income_URL, params: ["token" : TMHttpUser.token() ?? "", "type" : "2", "status" : status], success: { [weak self] (obj: IncomeInfo) in
            self?.hideHUD()
            self?.tableView.mj_header.endRefreshing()
            if "success" == obj.status {
                self?.unverify.text = "¥\(obj.data?.wait ?? 0.00)"
                self?.verify.text = "¥\(obj.data?.ok ?? 0.00)"
                self?.withdrawData = obj.data
                self?.withdraws = (obj.data?.result)!
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
    /** 更多 */
    @objc func loadMore() {
        getRequest(baseUrl: Income_URL, params: ["token" : TMHttpUser.token() ?? "", "type" : "2", "status" : status, "page" : "\(withdrawData?.page ?? 1)"], success: { [weak self] (obj: IncomeInfo) in
            self?.tableView.mj_footer.endRefreshing()
            if "success" == obj.status {
                self?.withdraws += (obj.data?.result)!
                self?.tableView.reloadData()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.tableView.mj_footer.endRefreshing()
            self.inspectError()
        }
    }
    /** 取消提现 */
    func loadCancel(ID: String) {
        showHUD()
        getRequest(baseUrl: CancelWithdraw_URL, params: ["token" : TMHttpUser.token() ?? "", "mid" : ID], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.load()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
        }
    }
    
    // MARK: - Callbacks
    @IBAction func action_unsettlement() {
        status = "0"
        load()
    }
    
    @IBAction func action_settlement() {
        status = "1"
        load()
    }
    
    @objc func action_withdraw() {
        
        let applyWithdraw = ApplyWithdrawController.init(nibName: "ApplyWithdrawController", bundle: getBundle())
        applyWithdraw.withdrawData = withdrawData
        navigationController?.pushViewController(applyWithdraw, animated: true)
    }
    
    func callbacks(cell: WithdrawRecordCell) {
        cell.cancelBlock = { [weak self] (cell, withdraw) in
            self?.loadCancel(ID: withdraw.id)
        }
    }
    
    /** Check Footer */
    func checkFooterState() {
        tableView.mj_footer.isHidden = (withdraws.count == 0)
        if (withdrawData?.page ?? 1) >= (withdrawData?.totalpage ?? 1) {
            tableView.mj_footer.endRefreshingWithNoMoreData()
        } else {
            tableView.mj_footer.endRefreshing()
        }
    }
}

extension WithdrawRecordController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkFooterState()
        return withdraws.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellName(WithdrawRecordCell.self)) as! WithdrawRecordCell
        callbacks(cell: cell)
        cell.withdraw = withdraws[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
    
    
    
    
    
    
    
}









