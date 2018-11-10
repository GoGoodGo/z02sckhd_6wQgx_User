//
//  QRCodeController.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/3.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import TMSDK
import YHTool

class QRCodeController: TMViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var qrErrorView: UIView!
    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var headTop: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的邀请码"
        setupUI()
        loadUserDetial()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        headTop.constant = HeightPercent(150)
        img.layer.borderColor = UIColor.white.cgColor
        
        let user = TMHttpUserInstance.sharedManager()
        let config = TMEngineConfig.instance()
        let url = URL.init(string: (config?.domain)! + (user?.head_pic ?? ""))
        img.kf.setImage(with: url)
        name.text = user?.member_name
    }
    
    /** 获取用户信息 */
    func loadUserDetial() {
        showHUD()
        getRequest(baseUrl: UserDetial_URL, params: ["token" : TMHttpUser.token() ?? TestToken], success: { [weak self] (obj: UserInfo) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.isShowError(isShow: false)
                self?.code.text = obj.data?.code
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
    }
    /** 是否显示推荐码 */
    func isShowError(isShow: Bool) {
        qrErrorView.isHidden = !isShow
//        if !isShow {
//            navigationController?.navigationBar.barStyle = .black
//            navigationController?.navigationBar.isTranslucent = true
//        } else {
//            navigationController?.navigationBar.barStyle = .default
//            navigationController?.navigationBar.isTranslucent = false
//        }
    }
    
    // MARK: - Callbacks
    @IBAction func action_browse() {
        
    }
    
    
    
    
    
    
    
    
    

}
