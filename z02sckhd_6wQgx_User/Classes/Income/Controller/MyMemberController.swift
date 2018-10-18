//
//  MyMemberController.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/3.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import MJRefresh
import YHTool
import TMSDK

class MyMemberController: UIViewController {
    
    @IBOutlet weak var segmentContent: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var members = [Member]()
    var memberData: MemberData?
    
    let titles = ["一级会员", "二级会员", "三级会员"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "我的会员"
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        segmentContent.addSubview(segmentView)
        
        tableView.register(UINib.init(nibName: CellName(MemberCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(MemberCell.self))
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(load))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        load()
    }
    /** 加载会员 */
    @objc func load() {
        showHUD()
        getRequest(baseUrl: MyMember_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "page" : "1"], success: { [weak self] (obj: MyMemberInfo) in
            self?.hideHUD()
            self?.tableView.mj_header.endRefreshing()
            if "success" == obj.status {
                self?.members = (obj.data?.result)!
                self?.memberData = obj.data
                self?.memberData?.page += 1
                self?.tableView.reloadData()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.tableView.mj_header.endRefreshing()
            self.inspectError()
        }
    }
    
    @objc func loadMore() {
        getRequest(baseUrl: MyMember_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "page" : "\(memberData?.page)"], success: { [weak self] (obj: MyMemberInfo) in
            self?.tableView.mj_footer.endRefreshing()
            if "success" == obj.status {
                self?.members += (obj.data?.result)!
                self?.memberData?.page += 1
                self?.tableView.reloadData()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.tableView.mj_footer.endRefreshing()
            self.inspectError()
        }
    }
    /** Check Footer */
    func checkFooterState() {
        tableView.mj_footer.isHidden = (members.count == 0)
        if (memberData?.page ?? 1) >= (memberData?.totalpage ?? 1) {
            tableView.mj_footer.endRefreshingWithNoMoreData()
        } else {
            tableView.mj_footer.endRefreshing()
        }
    }
    
    // MARK: - Getter
    private lazy var segmentView: YHSegmentView = {
        
        let view = YHSegmentView.init(frame: CGRect.init(x: 0, y: 0, width: WIDTH, height: 50), titles: self.titles)
        view.normalColor = HexString("#666666")
        view.selectedColor = HexString("#ff5b63")
        view.indicatorColor = HexString("#ff5b63")
        return view
    }()
    
}

extension MyMemberController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkFooterState()
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellName(MemberCell.self)) as! MemberCell
        cell.member = members[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    
}









