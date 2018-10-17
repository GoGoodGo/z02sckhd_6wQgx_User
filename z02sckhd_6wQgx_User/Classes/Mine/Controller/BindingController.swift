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
    
    @IBOutlet weak var binding: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "分销绑定"
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
