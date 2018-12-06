//
//  SetupAddressView.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/6.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool

class SetupAddressView: UIView {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var addressContent: UIView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var province: UIButton!
    @IBOutlet weak var city: UIButton!
    @IBOutlet weak var district: UIButton!
    @IBOutlet weak var detailAddress: UITextField!
    @IBOutlet weak var detialAddressView: UIView!
    @IBOutlet weak var sureBtn: UIButton!
    
    var address: NSDictionary?
    var citys = [String]()
    var districts = [[String]]()
    var provinceIndex = 0
    var cityIndex = 0
    var cityKey = ""
    var isUpdate = false
    
    var addressOption: ((_ tag: Int, _ title: String) -> Void)?
    var sure: ((_ name: String, _ phone: String, _ detial: String, _ type: AddressType) -> Void)?
    var hint: ((_ msg: String) -> Void)?
    var currentBtn: UIButton?
    let btnTag = 555

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(self)
        self.alpha = 0
        setupUI()
        getAddress()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        province.layer.borderColor = HexString("#dbdbdb").cgColor
        city.layer.borderColor = HexString("#dbdbdb").cgColor
        district.layer.borderColor = HexString("#dbdbdb").cgColor
        
        nameView.layer.borderColor = HexString("#dbdbdb").cgColor
        phoneView.layer.borderColor = HexString("#dbdbdb").cgColor
        detialAddressView.layer.borderColor = HexString("#dbdbdb").cgColor
        
        name.delegate = self
        phone.delegate = self
        detailAddress.delegate = self
        
//        content.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(action_tapContent)))
//        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(action_tap)))
        
        content.addSubview(pullDownView)
        callbacksPullDown()
    }
    
    // MARK: - XIB View
    public class func addressView() -> Any? {
        
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
        pullDownView.close()
        endEditing(true)
    }
    /** 获取地址信息 */
    private func getAddress() {
        let path = getBundle().path(forResource: "Address", ofType: "plist")
        address = NSDictionary.init(contentsOfFile: path!)
    }
    
    private func maskViewAnimail(isShow: Bool) {
        
        let alpha: CGFloat = isShow ? 1 : 0
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = alpha
        })
    }
    
    private func setupPullDown(sender: UIButton) {
        
        let point = addressContent.convert(CGPoint.init(x: sender.frame.minX, y: sender.frame.maxY), to: content)
        pullDownView.frame = CGRect.init(x: point.x - 15, y: point.y, width: sender.frame.size.width + 30, height: 0)
        pullDownView.onlyOpen()
    }
    
    // MARK: - Callbacks
    @IBAction func action_option(_ sender: UIButton) {
        self.endEditing(true)
        let tag = sender.tag - btnTag
        currentBtn = sender
        switch tag {
        case 0:
            pullDownView.titles = address?.allKeys
        case 1:
            if isUpdate {
                cityKey = address?.allKeys[provinceIndex] as! String
            }
            let array = address?.value(forKey: cityKey) as! Array<Any>
            let city = array.first as! Dictionary<String, Array<String>>
            var titles = [String]()
            for title in city.keys {
                titles.append(title)
            }
            var values = [[String]]()
            for value in city.values {
                values.append(value)
            }
            districts = values
            citys = titles
            pullDownView.titles = citys
        case 2:
            if districts.count > 0 {
                pullDownView.titles = districts[cityIndex]
            }
        default: return
        }
        setupPullDown(sender: sender)
    }
    
    @IBAction func action_tapContent(_ sender: UIButton) {
        endEditing(true)
    }
    
    @objc func action_tap() {
        diss()
    }
    
    @objc func action_tapContent() {
        
    }
    
    @IBAction func action_sure() {
        if let click = sure {
            click(name.text!, phone.text!, detailAddress.text!, addressType)
        }
    }
    
    private func callbacksPullDown() {
        pullDownView.selectedRowBlock = { [weak self] (title, index) in
            self?.currentBtn?.setTitle(title, for: .normal)
            let tag = (self?.currentBtn?.tag)! - (self?.btnTag)!
            if tag == 0 {
                self?.provinceIndex = index
                self?.isUpdate = true
            } else if tag == 1 {
                self?.cityIndex = index
            }
            if let click = self?.addressOption {
                click(tag, title!)
            }
        }
    }
    
    // MARK: - Setter
    var addressModel: Address? {
        didSet {
            name.text = addressType == .add ? "" : addressModel?.consignee
            phone.text = addressType == .add ? "" : addressModel?.tel
            detailAddress.text = addressType == .add ? "" : addressModel?.address_name
            if let regionArr = addressModel?.address.components(separatedBy: " ") {
                province.setTitle(regionArr.first, for: .normal)
                cityKey = addressType == .add ? "" : regionArr.first!
                city.setTitle(regionArr[1], for: .normal)
                district.setTitle(regionArr.last, for: .normal)
            }
        }
    }
    
    var addressType: AddressType = .edit {
        didSet {
            switch addressType {
            case .add:
                title.text = "请添加收货地址"
                sureBtn.setTitle("确认添加", for: .normal)
            case .edit:
                title.text = "请设置收获地址"
                sureBtn.setTitle("确认编辑", for: .normal)
            default: return
            }
        }
    }
    
    // MARK: - Getter
    lazy var pullDownView: YHPullDownView = {
        
        let view = YHPullDownView.init()
        view.frame = CGRect.init(x: 0, y: 0, width: 100, height: 0)
        view.isSelectedCancel = true
        view.titles = ["请选择省市"]
        return view
    }()
    

}

extension SetupAddressView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            if let block = hint {
                block("不能输入空格！")
            }
            return false
        }
        
        if textField == phone && range.location >= 11 {
            let index = textField.text?.index((textField.text?.startIndex)!, offsetBy: 11)
            textField.text = textField.text?.substring(to: index!)
            if let block = hint {
                block("手机号码长度不正确！")
            }
            return false
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == phone && !(phone.text?.isValidateMobile())! {
            if let block = hint {
                block("手机号格式错误！")
            }
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        pullDownView.close()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
    
    
    
    
}
