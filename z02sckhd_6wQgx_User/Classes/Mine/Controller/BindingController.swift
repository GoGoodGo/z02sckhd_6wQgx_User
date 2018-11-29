//
//  BindingController.swift
//  z02sckhd_6wQgx_User
//
//  Created by Healson on 2018/10/17.
//

import UIKit
import TMSDK
import YHTool

class BindingController: UIViewController {
    
    @IBOutlet weak var bindingLabel: UILabel!
    @IBOutlet weak var binding: UITextField!
    @IBOutlet weak var bindingBtn: UIButton!
    @IBOutlet weak var bindingTop: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "分销绑定"
        bindingTop.constant = HeightPercent(180)
        binding.layer.borderColor = HexString("#e2e2e2").cgColor
        
        loadUserDetial()
    }
    
    /** 获取用户信息 */
    func loadUserDetial() {
        showHUD()
        getRequest(baseUrl: UserDetial_URL, params: ["token" : TMHttpUser.token() ?? TestToken], success: { [weak self] (obj: UserInfo) in
            self?.hideHUD()
            if "success" == obj.status {
                if obj.data?.pid != 0 {
                    self?.bindingLabel.text = "您已绑定\(obj.data?.pidname ?? "")"
                    self?.binding.text = obj.data?.pidcode
                    self?.binding.isEnabled = false
                    self?.bindingBtn.isEnabled = false
                }
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
    }
    
    func bindingUser(code: String) {
        showHUD()
        getRequest(baseUrl: Binding_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "code" : code], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.showAutoHideHUD(message: "绑定成功！", completed: {
                    self?.navigationController?.popViewController(animated: true)
                })
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
    }
    
    @IBAction func action_binding(_ sender: UIButton) {
        if let code = binding.text {
            bindingUser(code: code)
        } else {
            showAutoHideHUD(message: "请输入邀请码！")
        }
    }
    
    

}
