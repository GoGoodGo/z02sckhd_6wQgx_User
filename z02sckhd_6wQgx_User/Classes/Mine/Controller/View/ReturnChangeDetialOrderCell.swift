//
//  ReturnChangeDetialOrderCell.swift
//  z02sckhd_6wQgx_User
//
//  Created by Healson on 2018/10/29.
//

import UIKit
import YHTool

class ReturnChangeDetialOrderCell: UITableViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    var cellType = 0

    override func awakeFromNib() {
        super.awakeFromNib()
    
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: CellName(ReturnChangeDetialCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(ReturnChangeDetialCell.self))
    }
    
    // MARK: - Setter
    var orders = [MyOrder]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override var frame: CGRect {
        didSet {
            let y:CGFloat = 21
            var tempFrame = frame
            tempFrame.origin.y += y
            tempFrame.size.height -= 1
            super.frame = tempFrame
        }
    }
}

extension ReturnChangeDetialOrderCell: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSorce
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders[section]._goods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellName(ReturnChangeDetialCell.self)) as! ReturnChangeDetialCell
        cell.orderGoods = orders[indexPath.section]._goods[indexPath.row]
        
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = MyOrderHeader.headerView() as! MyOrderHeader
        header.type = cellType
        header.order = orders[section]
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let goods = orders[indexPath.section]._goods[indexPath.row]
        let size = goods.returninfo?.reply.textSize(font: UIFont.systemFont(ofSize: 12), maxSize: CGSize.init(width: WIDTH - 100, height: 400))
        return HeightPercent(190) + (size?.height ?? 0)
    }
}
