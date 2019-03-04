//
//  ReturnChangeCell.swift
//  z02sckhd_6wQgx_User
//
//  Created by Healson on 2018/9/28.
//

import UIKit
import YHTool

class ReturnChangeCell: UITableViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: YHTextView!
    
    let btnTag = 518
    var reasones = ["七天无理由退换", "大小/尺寸与商品描述不符", "颜色/图案/款式与商品描述不符", "材料/面料与商品描述不符", "功能/效果与商品描述不符", "规格/参数与商品描述不符", "卖家发错货", "其他"]
    var tempBtn: UIButton?
    var type = "1"
    var reason = ""
    var describe = ""
    var returnReason: ((_ type: String, _ reason: String, _ describe: String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        textView.placeholder = "请输入退换货原因..."
        textView.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.allowsMultipleSelection = true
        tableView.register(UINib.init(nibName: CellName(ReturnChangeReasonCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(ReturnChangeReasonCell.self))
        
        tempBtn = self.viewWithTag(btnTag) as! UIButton
    }
    /** 传值 */
    func deliverInfo() {
        if let click = returnReason {
            click(type, reason, describe)
        }
    }
    
    @IBAction func action_returnChange(_ sender: UIButton) {
        tempBtn?.isSelected = false
        sender.isSelected = true
        tempBtn = sender
        type = sender.tag == btnTag ? "1" : "2"
        deliverInfo()
    }
}

extension ReturnChangeCell: UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    // MARK: - UITableViewDataSorce
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reasones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellName(ReturnChangeReasonCell.self)) as! ReturnChangeReasonCell
        cell.reasonMsg = reasones[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reason = reasones[indexPath.row]
        deliverInfo()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35.0
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        describe = textView.text
        deliverInfo()
    }
    
}








