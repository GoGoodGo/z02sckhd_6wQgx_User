//
//  MyMemberController.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/3.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool

class MyMemberController: UIViewController {
    
    @IBOutlet weak var segmentContent: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let titles = ["一级会员10人", "二级会员8人", "三级会员100人"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "我的会员"
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        segmentContent.addSubview(segmentView)
        
        tableView.tableFooterView = nil
        tableView.register(UINib.init(nibName: CellName(MemberCell.self), bundle: nil), forCellReuseIdentifier: CellName(MemberCell.self))
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellName(MemberCell.self)) as! MemberCell
        
        
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









