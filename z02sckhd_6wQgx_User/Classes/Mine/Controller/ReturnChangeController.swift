//
//  ReturnChangeController.swift
//  z02sckhd_6wQgx_User
//
//  Created by Healson on 2018/9/28.
//

import UIKit
import YHTool
import TMSDK

class ReturnChangeController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var orderResult: MyOrderResult?
    var subIndexPath: IndexPath?
    var returnBtn: UIButton?
    var type = "1" // 退货
    var reason = ""
    var describe = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "退换货"
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 60
//        tableView.sectionFooterHeight = UITableView.automaticDimension
//        tableView.estimatedSectionFooterHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.register(UINib.init(nibName: CellName(OrderGoodsCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(OrderGoodsCell.self))
        tableView.register(UINib.init(nibName: CellName(ReturnChangeCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(ReturnChangeCell.self))
        
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 70, right: 0)
    }
    /** 退换货 */
    func applyReturn() {
        showHUD()
        let order = orderResult?._orders[subIndexPath?.section ?? 0]
        let goods = order?._goods[subIndexPath?.row ?? 0]
        getRequest(baseUrl: ReturnGoods_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "order_id" : order?.order_id ?? "", "rec_id" : goods?.rec_id ?? "", "type" : type, "reson" : reason, "desc" : describe], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                let typeTitle = self?.type == "1" ? "退货" : "换货"
                self?.showAutoHideHUD(message: typeTitle + "成功,等待商家处理！", completed: {
                    self?.returnBtn?.isEnabled = false
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
    
    @IBAction func action_apply(_ sender: UIButton) {
        applyReturn()
    }
    
}

extension ReturnChangeController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSorce
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return section == 0 ? (orderResult?._orders.first?._goods.count ?? 0) : 1
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName(OrderGoodsCell.self)) as! OrderGoodsCell
//            cell.orderGoods = orderResult?._orders.first?._goods[indexPath.row]
            let order = orderResult?._orders[subIndexPath?.section ?? 0]
            cell.orderGoods = order?._goods[subIndexPath?.row ?? 0]
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName(ReturnChangeCell.self)) as! ReturnChangeCell
            cell.returnReason = { [weak self] (type, reason, describe) in
                self?.type = type
                self?.reason = reason
                self?.describe = describe
            }
            
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 { return nil }
        let header = LogisticsGoodsHeader.headerView() as! LogisticsGoodsHeader
        header.orderInfo = orderResult?._orders[subIndexPath?.section ?? 0]
        
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        if section == 1 { return nil }
//        let footer = LogisticsGoodsFooter.footerView() as! LogisticsGoodsFooter
//        footer.result = orderResult
//
//        return footer
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 1 ? 0 : tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
//        return tableView.sectionFooterHeight
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.endEditing(true)
    }
    
}









