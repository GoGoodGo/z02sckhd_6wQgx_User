//
//  SignInController.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/6.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool

let SendCodeTime = 60

class SignInController: UIViewController {
    
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var pwdView: UIView!
    @IBOutlet weak var headImg: UIButton!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var verifyCode: UIButton!
    @IBOutlet weak var code: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var timer: Timer?
    var second = SendCodeTime
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "会员注册"
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        phoneView.layer.borderColor = SeparatorColor.cgColor
        codeView.layer.borderColor = SeparatorColor.cgColor
        pwdView.layer.borderColor = SeparatorColor.cgColor
        
    }
    
    @IBAction func action_headImage(_ sender: UIButton) {
        
        
    }
    
    @IBAction func action_verifyCode(_ sender: UIButton) {
        
        view.endEditing(true)
        sender.isUserInteractionEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(action_timer), userInfo: nil, repeats: true)
        timer?.fireDate = NSDate.distantPast
        
    }
    
    @objc private func action_timer() {
        
        second -= 1
        if second <= 0 {
            second = SendCodeTime
            verifyCode.isUserInteractionEnabled = true
            verifyCode.setTitle("获取验证码", for: .normal)
            timer?.invalidate()
            timer = nil
            return
        }
        verifyCode.setTitle(String.init(format: "%lds", second), for: .normal)
    }
    
    @IBAction func action_signIn() {
        
        
    }
    
    
    
    

}
