//
//  AddressMaskView.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/6.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit

class AddressMaskView: UIView {
    
    var sureDelete: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(self)
        self.alpha = 0
    }
    
    // MARK: - XIB View
    public class func maskView() -> Any? {
        
        return bundle(self).loadNibNamed(String(describing: self), owner: nil, options: nil)?.last
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        diss()
    }
    
    public func show() {
        maskViewAnimail(isShow: true)
    }
    
    public func diss() {
        maskViewAnimail(isShow: false)
    }
    
    private func maskViewAnimail(isShow: Bool) {
        
        let alpha: CGFloat = isShow ? 1 : 0
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = alpha
        })
    }
    
    @IBAction func action_sure() {
        if let click = sureDelete {
            click()
            diss()
        }
    }
    
    @IBAction func action_cancel() {
        diss()
    }
    
    

}
