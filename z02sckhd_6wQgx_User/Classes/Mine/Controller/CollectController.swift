//
//  CollectController.swift
//  TianMaUser
//
//  Created by YH_O on 2018/8/11.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import MJRefresh
import YHTool

class CollectController: UIViewController {
    
    @IBOutlet weak var segmentContent: UIView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedIndex = 0
    var collectInfo: CollectInfo?
    var goods = [Collect]()
    var stores = [Collect]()
    
    let gap: CGFloat = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的收藏"
        setupUI()
    }
    // MARK: - PrivateMethod
    private func setupUI() {
        
        segmentContent.addSubview(segmentView)
        segmentCallbacks()
        
        let width = (WIDTH - gap * 3) / 2
        layout.itemSize = CGSize.init(width: width, height: getHeight(index: 0))
        layout.sectionInset = UIEdgeInsets.init(top: gap, left: gap, bottom: gap, right: gap)
        
        collectionView.register(UINib.init(nibName: CellName(CollectGoodsCell.self), bundle: bundle(type(of: self))), forCellWithReuseIdentifier: CellName(CollectGoodsCell.self))
        collectionView.register(UINib.init(nibName: CellName(CollectStoreCell.self), bundle: bundle(type(of: self))), forCellWithReuseIdentifier: CellName(CollectStoreCell.self))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(load))
        collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        
        load()
    }
    
    /** 我的收藏 */
    @objc func load() {
        showHUD()
        getRequest(baseUrl: MyCollect_URL, params: ["token" : Singleton.shared.token, "type" : "\(selectedIndex + 1)", "page" : "1"], success: { [weak self] (obj: CollectInfo) in
            self?.hideHUD()
            self?.collectionView.mj_header.endRefreshing()
            self?.collectInfo?.data?.result.removeAll()
            if "success" == obj.status {
                self?.collectInfo = obj
                self?.collectInfo?.data?.page += 1
            } else {
                self?.inspect(model: obj)
            }
            self?.collectionView.reloadData()
        }) { (error) in
            self.collectionView.mj_header.endRefreshing()
            self.inspectError()
        }
    }
    /** 加载更多 */
    @objc func loadMore() {
        getRequest(baseUrl: MyCollect_URL, params: ["token" : Singleton.shared.token, "type" : "\(selectedIndex + 1)", "page" : "\(collectInfo?.data?.page ?? 2)"], success: { [weak self] (obj: CollectInfo) in
            if "success" == obj.status {
                self?.collectInfo?.data?.page += 1
                self?.collectInfo?.data?.result += (obj.data?.result)!
                self?.collectionView.reloadData()
            } else {
                self?.inspect(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 取消收藏 */
    func loadCancel(indexPath: IndexPath) {
        let collect = collectInfo?.data?.result[indexPath.row]
        showHUD()
        getRequest(baseUrl: CancelCollect_URL, params: ["token" : Singleton.shared.token, "id" : (collect?.rec_id)!], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.collectInfo?.data?.result.remove(at: indexPath.row)
                self?.collectionView.reloadData()
            } else {
                self?.inspect(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    // MARK: - Check Footer
    func checkFooterState() {
        if let data = collectInfo?.data {
            collectionView.mj_footer.isHidden = (data.result.count == 0)
            if data.page >= data.totalpage {
                collectionView.mj_footer.endRefreshingWithNoMoreData()
            } else {
                collectionView.mj_footer.endRefreshing()
            }
        } else {
            collectionView.mj_footer.isHidden = true
        }
    }
    
    /** 商品店铺筛选 */
    func siftData() {
        let result = collectInfo?.data?.result
        for collect in result! {
            if collect.type == "1" {
                goods.append(collect)
            } else {
                stores.append(collect)
            }
        }
    }
    
    private func getHeight(index: Int) -> CGFloat {
        let width = (WIDTH - gap * 3) / 2
        var height = width + gap + 60 + 30
        if index == 1 {
            height = width / 2 + gap + 35 + 30
        }
        return height
    }
    
    // MARK: - Callbacks
    func callbacks(cell: CollectGoodsCell) {
        cell.cancelBlock = { [weak self] cell in
            let indexPath = self?.collectionView.indexPath(for: cell)
            self?.loadCancel(indexPath: indexPath!)
        }
    }
    func callbacks(cell: CollectStoreCell) {
        cell.cancelBlock = { [weak self] cell in
            let indexPath = self?.collectionView.indexPath(for: cell)
            self?.loadCancel(indexPath: indexPath!)
        }
    }
    private func segmentCallbacks() {
        segmentView.clickItemBlock = { [weak self] (index) in
            self?.selectedIndex = index
            self?.layout.itemSize = CGSize.init(width: (WIDTH - (self?.gap)! * 3) / 2, height: (self?.getHeight(index: index))!)
            self?.load()
        }
    }
    
    // MARK: - Getter
    private lazy var segmentView: YHSegmentView = {
        
        let view = YHSegmentView.init(frame: CGRect.init(x: 0, y: 0, width: WIDTH, height: 50), titles: ["商品", "店铺"])
        view.normalColor = HexString("#444")
        view.selectedColor = HexString("#ff5b63")
        view.indicatorColor = HexString("#ff5b63")
        return view
    }()
}

extension CollectController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        checkFooterState()
        return (collectInfo?.data?.result.count) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if selectedIndex == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName(CollectGoodsCell.self), for: indexPath) as! CollectGoodsCell
            cell.collect = collectInfo?.data?.result[indexPath.row]
            callbacks(cell: cell)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName(CollectStoreCell.self), for: indexPath) as! CollectStoreCell
            callbacks(cell: cell)
            cell.collect = collectInfo?.data?.result[indexPath.row]
            
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    
}






