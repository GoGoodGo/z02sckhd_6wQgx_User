//
//  GoodsController.swift
//  TianMaUser
//
//  Created by YH_O on 2018/7/24.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import MJRefresh
import YHTool
import TMSDK

public class GoodsController: TMViewController {
    
    let gap: CGFloat = 15
    
    var rowHeight: CGFloat = 0
    var goodsInfo: GoodsInfo?
    var headerView: GoodsHeaderView?
    var goodsList = [Goods]()
    var recommends = [Goods]()
    var categorys = [CategoryInfo]()
    var totalPage = 1
    var page = 1
    var sort = "" // 筛选
    var order = "" // 排序方式
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(login(notifi:)), name: NSNotification.Name(rawValue: "login"), object: nil)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "商品"
        
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        view.addSubview(collectionView)
        collectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadBest))
        collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        
        loadCategorys()
        loadBest()
        
    }
    /** 获取分类 */
    func loadCategorys() {
        getRequest(baseUrl: GoodsCategory_URL, params: nil, success: { [weak self] (obj: GoodsCategory) in
            if "success" == obj.status {
                self?.categorys = obj.data
                self?.collectionView.reloadData()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 获取推荐商品 */
    @objc func loadBest() {
        getRequest(baseUrl: GoodsList_URL, params: ["p" : "1", "is_best" : "1","token" : "\(TMHttpUserInstance.sharedManager().member_id)"], success: { [weak self] (obj: DataInfo) in
            self?.hideHUD()
            self?.collectionView.mj_header.endRefreshing()
            if "success" == obj.status {
                self?.recommends = (obj.data?.result)!
                self?.collectionView.reloadData()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.collectionView.mj_header.endRefreshing()
            self.inspectError()
        }
        loadNews()
    }
    /** 获取新品列表 */
    @objc func loadNews() {
        showHUD()
        getRequest(baseUrl: GoodsList_URL, params: ["sort" : sort, "order" : order, "p" : "1","token" : "\(TMHttpUserInstance.sharedManager().member_id)"], success: { [weak self] (obj: DataInfo) in
            self?.hideHUD()
            self?.collectionView.mj_header.endRefreshing()
            if "success" == obj.status {
                self?.goodsList = (obj.data?.result)!
                self?.totalPage = (obj.data?.totalpage)!
                self?.page += 1
                self?.collectionView.reloadData()
                
                
                
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.collectionView.mj_header.endRefreshing()
            self.hideHUD()
            self.inspectError()
        }
    }
    /** 获取更多 */
    @objc func loadMore() {
        getRequest(baseUrl: GoodsList_URL, params: ["sort" : sort, "order" : order, "p" : "\(page)"], success: { [weak self] (obj: DataInfo) in
            self?.collectionView.mj_footer.endRefreshing()
            if "success" == obj.status {
                self?.goodsList += (obj.data?.result)!
                self?.page += 1
                self?.collectionView.reloadData()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.collectionView.mj_footer.endRefreshing()
            self.inspectError()
        }
    }
    
    /** Check Footer */
    func checkFooterState() {
        collectionView.mj_footer.isHidden = (goodsList.count == 0)
        if page >= totalPage {
            collectionView.mj_footer.endRefreshingWithNoMoreData()
        } else {
            collectionView.mj_footer.endRefreshing()
        }
    }
    
    // MARK: - Callbacks
    private func callbacksHeader(header: GoodsHeaderView) {
        header.clickItemBlock = { [weak self] index in
            let category = self?.categorys[index]
            let typeCtrl = SecondaryTypesController.init(nibName: "SecondaryTypesController", bundle: getBundle())
            typeCtrl.pID = "\((category?.id)!)"
            typeCtrl.title = "\((category?.name)!)"
            self?.navigationController?.pushViewController(typeCtrl, animated: true)
        }
    }
    
    private func callbacksSegment(header: SegmentReusableView) {
        header.clickItem = { [weak self] index in
            if index == 0 {
                self?.sort = ""
                self?.order = "desc"
            } else {
                self?.sort = "s.sales"
            }
            self?.loadNews()
        }
    }
    
    // MARK: - Getter
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        
        let width = (WIDTH - gap * 3) / 2
        let height = width + gap + 60
        
        layout.itemSize = CGSize.init(width: width, height: height)
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets.init(top: gap, left: gap, bottom: gap, right: gap)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: WIDTH, height: HEIGHT), collectionViewLayout:self.layout)
        view.register(UINib.init(nibName: CellName(RecommendGoodsCell.self), bundle: getBundle()), forCellWithReuseIdentifier: CellName(RecommendGoodsCell.self))
        
        view.register(GoodsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellName(GoodsHeaderView.self))
        view.register(UINib.init(nibName: CellName(SegmentReusableView.self), bundle: getBundle()), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellName(SegmentReusableView.self))
        view.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: TabBarH, right: 0)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = UIColor.white
        return view
    }()
}


extension GoodsController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    // MARK: - UICollectionViewDataSource
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return recommends.count
        }
        checkFooterState()
        return goodsList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName(RecommendGoodsCell.self), for: indexPath) as! RecommendGoodsCell
        
        cell.goods = indexPath.section == 0 ? recommends[indexPath.row] : goodsList[indexPath.row]
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellName(GoodsHeaderView.self), for: indexPath) as! GoodsHeaderView
            callbacksHeader(header: headerView)
            self.headerView = headerView
            headerView.categorys = self.categorys
            
            return headerView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellName(SegmentReusableView.self), for: indexPath) as! SegmentReusableView
            callbacksSegment(header: headerView)
            
            return headerView
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var height: CGFloat = 60
        if section == 0 {
            height += headerView?.getHeaderHeight() ?? 0.00
        }
        return CGSize.init(width: WIDTH, height: height)
    }
    
    // MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let goods = indexPath.section == 0 ? recommends[indexPath.row] : goodsList[indexPath.row]
        let goodsDetialCtrl = GoodsDetialController.init(nibName: "GoodsDetialController", bundle: getBundle())
        goodsDetialCtrl.goodsID = "\(goods.goods_id)"
        navigationController?.pushViewController(goodsDetialCtrl, animated: true)
    }
    
    
    
    
}
