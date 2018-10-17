//
//  MineController.swift
//  TianMaUser
//
//  Created by YH_O on 2018/7/24.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool
import TMSDK
import MJRefresh

public class MineController: TMViewController {
    
    @IBOutlet weak var imgBtn: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var header: UIView!
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        imgBtn.layer.borderColor = UIColor.white.cgColor
        
        tableView.tableFooterView = nil
        tableView.register(UINib.init(nibName: CellName(MineInfoCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(MineInfoCell.self))
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(load))
    }
    
    @objc func load() {
        
        let user = TMHttpUserInstance.sharedManager()
        let config = TMEngineConfig.instance()
        let url = URL.init(string: (config?.domain)! + (user?.head_pic ?? ""))
        imgBtn.kf.setImage(with: url, for: .normal)
        name.text = user?.member_name
        tableView.mj_header.endRefreshing()
    }
    
    // MARK: - Callbacks
    @IBAction func action_userInfo(_ sender: UIButton) {
        
        let signInCtrl = SignInController.init(nibName: "SignInController", bundle: getBundle())
        navigationController?.pushViewController(signInCtrl, animated: true)
    }
}

extension MineController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellName(MineInfoCell.self)) as! MineInfoCell
        cell.index = indexPath.row
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let addressCtrl = AddressController.init(nibName: "AddressController", bundle: getBundle())
            navigationController?.pushViewController(addressCtrl, animated: true)
        case 1:
            let orderCtrl = MyOrderController.init(nibName: "MyOrderController", bundle: getBundle())
            navigationController?.pushViewController(orderCtrl, animated: true)
        case 2:
            let incomeCtrl = MyIncomeController.init(nibName: "MyIncomeController", bundle: getBundle())
            navigationController?.pushViewController(incomeCtrl, animated: true)
        case 3:
            let withdraw = WithdrawRecordController.init(nibName: "WithdrawRecordController", bundle: getBundle())
            navigationController?.pushViewController(withdraw, animated: true)
        case 4:
            let collectCtrl = CollectController.init(nibName: "CollectController", bundle: getBundle())
            navigationController?.pushViewController(collectCtrl, animated: true)
        case 5:
            let bindingCtrl = BindingController.init(nibName: "BindingController", bundle: getBundle())
            navigationController?.pushViewController(bindingCtrl, animated: true)
        default: return
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    
    
    
}







