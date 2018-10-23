//
//  IncomeController.swift
//  TianMaUser
//
//  Created by YH_O on 2018/7/24.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import MJRefresh
import YHTool
import TMSDK

public class IncomeController: TMViewController {
    
    @IBOutlet weak var withdraw: UILabel!
    @IBOutlet weak var income: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var header: UIView!
    
    var incomeData: IncomeData?
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isTranslucent = false
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "收益"
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        tableView.tableFooterView = nil
        header.height = HeightPercent(145)
        tableView.register(UINib.init(nibName: CellName(IncomeCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(IncomeCell.self))
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(load))
        load()
    }
    
    /** 获取收益 */
    @objc func load() {
        showHUD()
        getRequest(baseUrl: Income_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "type" : "11", "status" : "0"], success: { [weak self] (obj: IncomeInfo) in
            self?.hideHUD()
            self?.tableView.mj_header.endRefreshing()
            if "success" == obj.status {
                self?.withdraw.text = "¥\(obj.data?.ok ?? 0.00)"
                self?.income.text = "¥\(obj.data?.money ?? "0.00")"
                self?.incomeData = obj.data
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.tableView.mj_header.endRefreshing()
            self.inspectError()
        }
    }
    
    // MARK: - Callbacks
    @IBAction func action_withdraw() {
        let applyWithdraw = ApplyWithdrawController.init(nibName: "ApplyWithdrawController", bundle: getBundle())
        applyWithdraw.withdrawData = incomeData
        navigationController?.pushViewController(applyWithdraw, animated: true)
    }
    
    @IBAction func action_income() {
        let incomeCtrl = MyIncomeController.init(nibName: "MyIncomeController", bundle: getBundle())
        navigationController?.pushViewController(incomeCtrl, animated: true)
    }

}

extension IncomeController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellName(IncomeCell.self)) as! IncomeCell
        cell.index = indexPath.row
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let qrCodeCtrl = QRCodeController.init(nibName: "QRCodeController", bundle: getBundle())
            navigationController?.pushViewController(qrCodeCtrl, animated: true)
        case 1:
            let memberCtrl = MyMemberController.init(nibName: "MyMemberController", bundle: getBundle())
            navigationController?.pushViewController(memberCtrl, animated: true)
        case 2:
            let incomeCtrl = MyIncomeController.init(nibName: "MyIncomeController", bundle: getBundle())
            navigationController?.pushViewController(incomeCtrl, animated: true)
        case 3:
            let withdraw = WithdrawRecordController.init(nibName: "WithdrawRecordController", bundle: getBundle())
            withdraw.withdrawData = incomeData
            navigationController?.pushViewController(withdraw, animated: true)
        default: return
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    
    
    
    
    
    
    
    
    
}






