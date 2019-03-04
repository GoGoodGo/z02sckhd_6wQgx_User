//
//  AllCommentsController.swift
//  z02sckhd_6wQgx_User
//
//  Created by Healson on 2018/10/24.
//

import UIKit
import YHTool
import TMSDK

class AllCommentsController: TMViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var comments = [Comment]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "评论(\(comments.count))"
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        tableView.tableFooterView = nil
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        tableView.register(UINib.init(nibName: CellName(GoodsEvaluateCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(GoodsEvaluateCell.self))
    }
    // MARK: - Callbacks
    func callbacksWithCell(cell: GoodsEvaluateCell) {
        cell.clickItemBlock = { [weak self] (cell, index, images) in
            if images.count > 0 {
                let rect = CGRect.init(x: WIDTH / 2, y: HEIGHT / 2, width: 100, height: 100)
                UIApplication.shared.keyWindow?.addSubview((self?.fullScreenView)!)
                self?.fullScreenView.setupFullScreen(withFrame: rect, imgArray: images, index: UInt(index))
            }
        }
    }
    
    // MARK: - Getter
    lazy var fullScreenView: YHScrollView = {
       
        let view = YHScrollView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0), imageName: nil)
        view?.isCircle = false
        view?.isAutoScroll = false
        return view!
    }()

}

extension AllCommentsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellName(GoodsEvaluateCell.self)) as! GoodsEvaluateCell
        callbacksWithCell(cell: cell)
        cell.comment = comments[indexPath.row]
        cell.type = .all
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    
}
