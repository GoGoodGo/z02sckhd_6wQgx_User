//
//  QRCodeController.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/3.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class QRCodeController: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var qrCode: UIImageView!
    @IBOutlet weak var qrErrorView: UIView!
    
    var isAvailableQRCode = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isAvailableQRCode {
            navigationController?.navigationBar.barStyle = .black
            navigationController?.navigationBar.isTranslucent = true
        } else {
            navigationController?.navigationBar.barStyle = .default
            navigationController?.navigationBar.isTranslucent = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//    apiuser/detail
        self.title = "我的邀请码"
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        qrErrorView.isHidden = isAvailableQRCode
        img.layer.borderColor = UIColor.white.cgColor
    }
    
    // MARK: - Callbacks
    @IBAction func action_browse() {
        
    }
    
    
    
    
    
    
    
    
    

}
