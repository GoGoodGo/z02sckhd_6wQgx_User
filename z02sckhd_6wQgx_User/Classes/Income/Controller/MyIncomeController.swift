//
//  MyIncomeController.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/3.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import MJRefresh
import YHTool
import TMSDK

class MyIncomeController: TMViewController {
    
    @IBOutlet weak var unsettlement: UILabel!
    @IBOutlet weak var settlement: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var incomeData: IncomeData?
    var incomes = [Income]()
    var status = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的收益"
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        tableView.register(UINib.init(nibName: CellName(MyIncomeCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(MyIncomeCell.self))
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(load))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        load()
    }
    
    /** 获取收益 */
    @objc func load() {
        showHUD()
        getRequest(baseUrl: Income_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "type" : "11", "status" : status, "from" : "1"], success: { [weak self] (obj: IncomeInfo) in
            self?.hideHUD()
            self?.tableView.mj_header.endRefreshing()
            if "success" == obj.status {
                self?.unsettlement.text = "¥\(obj.data?.wait ?? "0.00")"
                self?.settlement.text = "¥\(obj.data?.ok ?? "0.00")"
                self?.incomeData = obj.data
                self?.incomeData?.page += 1
                self?.incomes = (obj.data?.result)!
                self?.tableView.reloadData()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.tableView.mj_header.endRefreshing()
            self.inspectError()
        }
    }
    
    @objc func loadMore() {
        getRequest(baseUrl: Income_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "type" : "11", "status" : status, "page" : "\(incomeData?.page ?? 1)", "from" : "1"], success: { [weak self] (obj: IncomeInfo) in
            self?.tableView.mj_footer.endRefreshing()
            if "success" == obj.status {
                self?.incomeData = obj.data
                self?.incomeData?.page += 1
                self?.incomes += (obj.data?.result)!
                self?.tableView.reloadData()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.tableView.mj_footer.endRefreshing()
            self.inspectError()
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
    
    /** Check Footer */
    func checkFooterState() {
        tableView.mj_footer.isHidden = (incomes.count == 0)
        if (incomeData?.page ?? 1) >= (incomeData?.totalpage ?? 1) {
            tableView.mj_footer.endRefreshingWithNoMoreData()
        } else {
            tableView.mj_footer.endRefreshing()
        }
    }

}

extension MyIncomeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkFooterState()
        return incomes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellName(MyIncomeCell.self)) as! MyIncomeCell
        cell.incomeData = incomes[indexPath.row]
        
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









