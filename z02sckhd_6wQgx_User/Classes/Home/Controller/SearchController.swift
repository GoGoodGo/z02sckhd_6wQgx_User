//
//  SearchController.swift
//  TianMaUser
//
//  Created by YH_O on 2018/7/26.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool
import MJRefresh

class SearchController: UIViewController {
    
    @IBOutlet weak var searchResult: UIButton!
    @IBOutlet weak var segmentContent: UIView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let gap: CGFloat = 15.0
    let titles = ["商品", "店铺"]
    
    var goods = [Goods]()
    var shops = [HomeShop]()
    var goodsInfo: GoodsInfo?
    var shopInfo: ShopListData?
    var currentIndex = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isTranslucent = false
        
        isShowSearchBar(isShow: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        isShowSearchBar(isShow: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - PrivateMethod
    private func setupUI() {
        
        segmentContent.addSubview(segmentView)
        segmentCallbacks()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.item(title: "搜索", titleColor: HexString("#2f9cf7"), target: self, action: #selector(action_search))
        
        let width = (WIDTH - gap * 3) / 2
        let height = width + gap + 60
        layout.itemSize = CGSize.init(width: width, height: height)
        layout.minimumLineSpacing = gap
        
        collectionView.register(UINib.init(nibName: CellName(RecommendGoodsCell.self), bundle: getBundle()), forCellWithReuseIdentifier: CellName(RecommendGoodsCell.self))
        collectionView.register(UINib.init(nibName: CellName(MerchantCell.self), bundle: getBundle()), forCellWithReuseIdentifier: CellName(MerchantCell.self))
        
        collectionView.contentInset = UIEdgeInsets.init(top: 5.0, left: gap, bottom: gap, right: gap)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(load))
        collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
    }
    
    @objc func load() {
        currentIndex == 0 ? searchGoods() : searchShops()
    }
    
    @objc func loadMore() {
        currentIndex == 0 ? loadMoreGoods() : loadMoreShops()
    }
    /** search */
    func searchGoods() {
        showHUD()
        getRequest(baseUrl: GoodsList_URL, params: ["keyword" : searchTextF.text!, "page" : "1"], success: { [weak self] (obj: DataInfo) in
            self?.hideHUD()
            self?.collectionView.mj_header.endRefreshing()
            if "success" == obj.status {
                self?.goods = (obj.data?.result)!
                self?.goodsInfo = obj.data
                self?.goodsInfo?.page += 1
                self?.collectionView.reloadData()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.collectionView.mj_header.endRefreshing()
            self.inspectError()
        }
    }
    func searchShops() {
        showHUD()
        getRequest(baseUrl: ShopList_URL, params: ["keyword" : searchTextF.text!, "page" : "1"], success: { [weak self] (obj: ShopListInfo) in
            self?.hideHUD()
            self?.collectionView.mj_header.endRefreshing()
            if "success" == obj.status {
                self?.shops = (obj.data?.result)!
                self?.shopInfo = obj.data
                self?.shopInfo?.page += 1
                self?.collectionView.reloadData()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.collectionView.mj_header.endRefreshing()
            self.inspectError()
        }
    }
    
    func loadMoreGoods() {
        getRequest(baseUrl: GoodsList_URL, params: ["keyword" : searchTextF.text!, "page" : "\(goodsInfo?.page ?? 1)"], success: { [weak self] (obj: DataInfo) in
            self?.collectionView.mj_footer.endRefreshing()
            if "success" == obj.status {
                self?.goods += (obj.data?.result)!
                self?.goodsInfo?.page += 1
                self?.collectionView.reloadData()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.collectionView.mj_footer.endRefreshing()
            self.inspectError()
        }
    }
    
    func loadMoreShops() {
        getRequest(baseUrl: ShopList_URL, params: ["keyword" : searchTextF.text!, "page" : "\(shopInfo?.page ?? 1)"], success: { [weak self] (obj: ShopListInfo) in
            self?.collectionView.mj_footer.endRefreshing()
            if "success" == obj.status {
                self?.shops = (obj.data?.result)!
                self?.shopInfo?.page += 1
                self?.collectionView.reloadData()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.collectionView.mj_footer.endRefreshing()
            self.inspectError()
        }
    }
    
    private func isShowSearchBar(isShow: Bool) {
        let alpha: CGFloat = isShow ? 0.2 : 0
        if isShow {
            navigationController?.navigationBar.addSubview(searchTextF)
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.searchTextF.backgroundColor = UIColor.lightGray.withAlphaComponent(alpha)
        }) { (isCompletion) in
            if isShow {
                self.navigationController?.navigationBar.addSubview(self.searchTextF)
            } else {
                self.searchTextF.removeFromSuperview()
            }
        }
    }
    /**  计算高度 */
    private func getRowHeight() -> CGFloat {
        
        let W = (WIDTH - gap * 3) / 2
        let commonH = gap
        var height = W + commonH + 60
        if currentIndex != 0 {
            height = W / 2 + commonH + 35
        }
        return height
    }
    /** Check Footer */
    func checkFooterState() {
        collectionView.mj_footer.isHidden = ((currentIndex == 0 ? goods.count : shops.count) == 0)
        if (currentIndex == 0 ? (goodsInfo?.page ?? 1) : (shopInfo?.page ?? 1)) >= (currentIndex == 0 ? (goodsInfo?.totalpage ?? 1) : (shopInfo?.totalpage ?? 1)) {
            collectionView.mj_footer.endRefreshingWithNoMoreData()
        } else {
            collectionView.mj_footer.endRefreshing()
        }
    }
    // MARK: - Callbacks
    @objc private func action_search() {
        navigationController?.navigationBar.endEditing(true)
        load()
    }
    
    private func segmentCallbacks() {
        segmentView.clickItemBlock = { [weak self] (index) in
            self?.navigationController?.navigationBar.endEditing(true)
            self?.currentIndex = index
            self?.load()
        }
    }
    
    // MARK: - Getter
    private lazy var segmentView: YHSegmentView = {
        
        let view = YHSegmentView.init(frame: CGRect.init(x: 0, y: 0, width: WIDTH, height: 50), titles: self.titles)
        view.normalColor = HexString("#444")
        view.selectedColor = HexString("#ff5b63")
        view.indicatorColor = HexString("#ff5b63")
        return view
    }()
    
    private lazy var searchTextF: YHTextField = {
        
        let height: CGFloat = 30
        let gap: CGFloat = 50
        let textField = YHTextField.init(frame: CGRect.init(x: gap - 10, y: (NavigationBarH - height - 20) / 2, width: WIDTH - gap * 2, height: height))
        textField.delegate = self
        textField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        textField.returnKeyType = .search
        textField.clearButtonMode = .whileEditing
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeholder = "请输入宝贝名称"
        textField.layer.cornerRadius = height / 2
        textField.fontSize = 12
        
        return textField
    }()
}

extension SearchController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        checkFooterState()
        return currentIndex == 0 ? goods.count : shops.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if currentIndex == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName(RecommendGoodsCell.self), for: indexPath) as! RecommendGoodsCell
            cell.goods = goods[indexPath.row]
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName(MerchantCell.self), for: indexPath) as! MerchantCell
            cell.shop = shops[indexPath.row]
            
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentIndex == 0 {
            let goodsDetialCtrl = GoodsDetialController.init(nibName: "GoodsDetialController", bundle: getBundle())
            goodsDetialCtrl.ID = goods[indexPath.row].goods_id
            goodsDetialCtrl.detialType = .detial
            navigationController?.pushViewController(goodsDetialCtrl, animated: true)
        } else {
            let storeCtrl = StoreController.init(nibName: "StoreController", bundle: getBundle())
            storeCtrl.ID = shops[indexPath.row].id
            navigationController?.pushViewController(storeCtrl, animated: true)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: (WIDTH - gap * 3) / 2, height: getRowHeight())
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationController?.navigationBar.endEditing(true)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        navigationController?.navigationBar.endEditing(true)
        
        return true
    }
}













