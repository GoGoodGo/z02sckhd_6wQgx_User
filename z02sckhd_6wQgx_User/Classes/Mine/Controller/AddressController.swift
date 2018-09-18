//
//  AddressController.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/6.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool

enum AddressType {
    case add
    case edit
}

class AddressController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var province = ""
    var city = ""
    var district = ""
    var aid = ""
    var index = 0
    
    var addresses = [Address]()
    var selectedAddress: (( _ address: Address, _ index: Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "收货地址"
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.item(title: "新增", titleColor: HexString("#3363ff"), target: self, action: #selector(action_add))
        
        tableView.tableFooterView = nil
        tableView.register(UINib.init(nibName: CellName(AddressCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(AddressCell.self))
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 10, right: 0)
        
        callbacksMask()
        load()
    }
    /** 加载地址 */
    func load() {
        showHUD()
        getRequest(baseUrl: Address_URL, params: ["token" : Singleton.shared.token], success: { [weak self] (obj: AddressInfo) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.addresses = obj.data
                self?.tableView.reloadData()
            } else {
                self?.inspect(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 新增地址 */
    func addAddress(name: String, phone: String, detial: String) {
        let address = province + " " + city + " " + district
        let params = ["token" : Singleton.shared.token, "address" : address, "consignee" : name, "tel" : phone, "address_name" : detial]
        showHUD()
        getRequest(baseUrl: AddAddress_URL, params: params, success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.setAddressView.diss()
                self?.load()
            } else {
                self?.inspect(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 编辑地址 */
    func editAddress(name: String, phone: String, detial: String) {
        let address = province + " " + city + " " + district
        let params = ["aid" : aid, "token" : Singleton.shared.token, "address" : address, "consignee" : name, "tel" : phone, "address_name" : detial]
        showHUD()
        getRequest(baseUrl: EditAddress_URL, params: params, success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.setAddressView.diss()
                self?.load()
            } else {
                self?.inspect(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 删除地址 */
    func delete() {
        getRequest(baseUrl: DelAddress_URL, params: ["aid" : aid, "token" : Singleton.shared.token], success: { [weak self] (obj: BaseModel) in
            if "success" == obj.status {
                self?.maskView.diss()
                self?.addresses.remove(at: (self?.index)!)
                self?.tableView.reloadData()
            } else {
                self?.inspect(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 设置默认 */
    func isDefault() {
        showHUD()
        getRequest(baseUrl: DefaultAddress_URL, params: ["address_id" : aid, "token" : Singleton.shared.token], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.load()
            } else {
                self?.inspect(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    
    func regionEdit(regionStr: String) {
        let regionArr = regionStr.components(separatedBy: " ")
        province = regionArr.first!
        city = regionArr[1]
        district = regionArr.last!
    }
    
    // MARK: - Callbacks
    @objc func action_add() {
        setAddressView.show()
        setAddressView.addressType = .add
    }
    
    private func callbacks(cell: AddressCell) {
        cell.addressSet = { [weak self] (tag, selectedCell) in
            let indexPath = self?.tableView.indexPath(for: selectedCell)
            let address = self?.addresses[(indexPath?.row)!]
            self?.aid = (address?.address_id)!
            self?.index = (indexPath?.row)!
            switch tag {
            case 0:
                self?.isDefault()
            case 1:
                self?.setAddressView.show()
                self?.setAddressView.addressType = .edit
                self?.setAddressView.addressModel = address
                self?.regionEdit(regionStr: (address?.address)!)
            case 2:
                self?.maskView.show()
            default: return
            }
        }
    }
    
    private func callbacksMask() {
        maskView.sureDelete = { [weak self] in
            self?.delete()
        }
        setAddressView.sure = { [weak self] (name, phone, detial, type) in
            if type == .add {
                self?.addAddress(name: name, phone: phone, detial: detial)
            } else {
                self?.editAddress(name: name, phone: phone, detial: detial)
            }
        }
        setAddressView.addressOption = { [weak self] (tag, title) in
            switch tag {
            case 0:
                self?.province = title
            case 1:
                self?.city = title
            case 2:
                self?.district = title
            default: return
            }
        }
    }
    
    // MARK: - Getter
    private lazy var maskView: AddressMaskView = {
        
        let view = AddressMaskView.maskView() as! AddressMaskView
        view.frame = CGRect.init(x: 0, y: 0, width: WIDTH, height: HEIGHT)
        return view
    }()

    private lazy var setAddressView: SetupAddressView = {
       
        let view = SetupAddressView.addressView() as! SetupAddressView
        view.frame = CGRect.init(x: 0, y: 0, width: WIDTH, height: HEIGHT)
        return view
    }()
}


extension AddressController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellName(AddressCell.self)) as! AddressCell
        callbacks(cell: cell)
        let address = addresses[indexPath.row]
        cell.addressModel = address
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        if let click = selectedAddress {
            click(addresses[index], index)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
    
    
    
}








