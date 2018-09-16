//
//  IncomeController.swift
//  TianMaUser
//
//  Created by YH_O on 2018/7/24.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool

class IncomeController: UIViewController {
    
    @IBOutlet weak var withdraw: UILabel!
    @IBOutlet weak var income: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var header: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isTranslucent = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "收益"
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        tableView.tableFooterView = nil
        header.height = HeightPercent(145)
        tableView.register(UINib.init(nibName: CellName(IncomeCell.self), bundle: nil), forCellReuseIdentifier: CellName(IncomeCell.self))
        
        load()
    }
    
    /** 获取收益 */
    func load() {
        showHUD()
        getRequest(baseUrl: Income_URL, params: ["token" : Singleton.shared.token, "type" : "11", "status" : "0"], success: { [weak self] (obj: IncomeInfo) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.withdraw.text = "¥\(obj.data?.money ?? "0.00")"
                self?.income.text = "¥\(obj.data?.ok ?? 0.00)"
            } else {
                self?.inspect(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
    }
    
    // MARK: - Callbacks
    @IBAction func action_withdraw() {
        
    }
    
    @IBAction func action_income() {
        
        
    }

}

extension IncomeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellName(IncomeCell.self)) as! IncomeCell
        cell.index = indexPath.row
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let qrCodeCtrl = QRCodeController()
            navigationController?.pushViewController(qrCodeCtrl, animated: true)
        case 1:
            let memberCtrl = MyMemberController()
            navigationController?.pushViewController(memberCtrl, animated: true)
        case 2:
            let incomeCtrl = MyIncomeController()
            navigationController?.pushViewController(incomeCtrl, animated: true)
        case 3:
            let withdraw = WithdrawRecordController()
            navigationController?.pushViewController(withdraw, animated: true)
        default: return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    
    
    
    
    
    
    
    
    
}






