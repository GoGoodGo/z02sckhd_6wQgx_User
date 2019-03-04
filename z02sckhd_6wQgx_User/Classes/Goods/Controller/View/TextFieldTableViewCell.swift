//
//  TextFieldTableViewCell.swift
//  AFNetworking
//
//  Created by 虞淞晴 on 2019/2/27.
//

import UIKit
import SnapKit

class TextFieldTableViewCell: UITableViewCell,UITextFieldDelegate {

    
    
    var closure:((_ tag:String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.textField.delegate = self
        
        self.setLayContraints()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setLayContraints(){
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(textField)
        
        
        titleLabel.snp.makeConstraints({ (make) in

            make.top.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(0)
            make.height.equalTo(45)
            make.width.equalTo(80)

        })

        textField.snp.makeConstraints({ (make) in

            make.left.equalTo(titleLabel.snp.right).offset(10)
            // 设置宽、高
            make.right.equalToSuperview().offset(-15)

            make.centerY.equalTo(titleLabel.snp.centerY).offset(0)


        })
        
        
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 13)
        
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField.init(frame: CGRect.zero)
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.textAlignment = .right
        return textField
    }()
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.closure != nil {
            self.closure!(textField.text ?? "")
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
