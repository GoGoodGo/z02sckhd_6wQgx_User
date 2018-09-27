//
//  SecondaryTypesController.swift
//  TianMaUser
//
//  Created by Healson on 2018/7/30.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import MJRefresh
import YHTool

class SecondaryTypesController: UIViewController {
    
    @IBOutlet weak var typeLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet weak var indicator: UIImageView!
    @IBOutlet weak var goodsLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var goodsCollectionView: UICollectionView!
    @IBOutlet weak var salesNum: YHButton!
    @IBOutlet weak var price: YHButton!
    
    let btnTag = 123
    let gap: CGFloat = 15
    
    var flag = 1
    var pID = ""
    var order = "desc"
    var sort = "s.sales"
    var goodsInfo: GoodsInfo?
    var goodsList = [Goods]()
    var categorys = [CategoryInfo]()
    var currentCategory: CategoryInfo?
    var page = 1
    var totalPage = 0
    var params = [String : String]()
    
    var goodsTitle = "商品"
    var tempBtn: UIButton?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = goodsTitle
        tempBtn = view.viewWithTag(btnTag) as? UIButton
        setupUI()
        
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        salesNum.btnLayout = .ImgRightTitleLeftMode
        price.btnLayout = .ImgRightTitleLeftMode
        
        typeLayout.minimumInteritemSpacing = gap
        typeLayout.itemSize = CGSize.init(width: 45, height: 55)
        let width = (WIDTH - gap * 3) / 2
        let height = width + gap + 60
        goodsLayout.itemSize = CGSize.init(width: width, height: height)
        typeCollectionView.register(UINib.init(nibName: CellName(SecondaryTypeCell.self), bundle: getBundle()), forCellWithReuseIdentifier: CellName(SecondaryTypeCell.self))
        goodsCollectionView.register(UINib.init(nibName: CellName(RecommendGoodsCell.self), bundle: getBundle()), forCellWithReuseIdentifier: CellName(RecommendGoodsCell.self))
        
        typeCollectionView.contentInset = UIEdgeInsets.init(top: gap, left: gap, bottom: gap, right: gap)
        goodsCollectionView.contentInset = UIEdgeInsets.init(top: gap, left: gap, bottom: gap, right: gap)
        typeCollectionView.delegate = self
        typeCollectionView.dataSource = self
        goodsCollectionView.delegate = self
        goodsCollectionView.dataSource = self
        
        
//        goodsCollectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(load))
        goodsCollectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        loadCategorys()
    }
    
    private func indicatorAnimate(center: CGPoint) {
        UIView.animate(withDuration: 0.2) {
            self.indicator.centerX = center.x
        }
    }
    
    // MARK: - Callbacks
    @IBAction func action_sort(_ sender: UIButton) {
        tempBtn?.isSelected = false
        sender.isSelected = true
        if sender != tempBtn { flag = 0 }
        let tag = sender.tag - btnTag
        if tag == 0 {
            sort = "s.sales"
        } else {
            sort = "s.price"
        }
        
        if flag % 2 == 1 {
            sender.setImage(getImage(type(of: self), "ico_img_sxxz"), for: .selected)
            tempBtn?.setImage(getImage(type(of: self), "ico_img_sx"), for: .normal)
            order = "asc"
        } else {
            sender.setImage(getImage(type(of: self), "ico_img_jxxz"), for: .selected)
            tempBtn?.setImage(getImage(type(of: self), "ico_img_jx"), for: .normal)
            order = "desc"
        }
        
        flag += 1
        
        tempBtn = sender
        indicatorAnimate(center: sender.center)
        load()
    }
    /** 默认选中类型 */
    func defaultSelected() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        typeCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        currentCategory = categorys[indexPath.row]
        
        load()
    }
    /** 获取子分类列表 */
    func loadCategorys() {
        let params = ["pid" : pID]
        getRequest(baseUrl: GoodsCategory_URL, params: params, success: { [weak self] (obj: GoodsCategory) in
            if "success" == obj.status {
                self?.categorys = obj.data
                if obj.data.count <= 0 { return }
                self?.typeCollectionView.reloadData()
                self?.defaultSelected()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 获取商品列表 */
    @objc func load() {
        
        showHUD()
        params = ["cate_id" : (currentCategory?.id)!, "sort" : sort, "order" : order, "p" : "1"]
        getRequest(baseUrl: GoodsList_URL, params: params, success: { [weak self] (obj: DataInfo) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.page += 1
                self?.goodsList = (obj.data?.result)!
                self?.totalPage = (obj.data?.totalpage)!
                self?.goodsCollectionView.reloadData()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
    }
    /** 获取更多 */
    @objc func loadMore() {
        params = ["cate_id" : (currentCategory?.id)!, "sid" : (currentCategory?.sid)!, "sort" : sort, "order" : order, "p" : "\(page)"]
        getRequest(baseUrl: GoodsList_URL, params: params, success: { [weak self] (obj: DataInfo) in
            if "success" == obj.status {
                self?.page += 1
                self?.goodsList += (obj.data?.result)!
                self?.goodsCollectionView.reloadData()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    
    /** Check Footer */
    func checkFooterState() {
        goodsCollectionView.mj_footer.isHidden = (goodsList.count == 0)
        if page >= totalPage {
            goodsCollectionView.mj_footer.endRefreshingWithNoMoreData()
        } else {
            goodsCollectionView.mj_footer.endRefreshing()
        }
    }
    
}

extension SecondaryTypesController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == typeCollectionView {
            return categorys.count
        } else {
            checkFooterState()
            return goodsList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == typeCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName(SecondaryTypeCell.self), for: indexPath) as! SecondaryTypeCell
            cell.category = categorys[indexPath.row]
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName(RecommendGoodsCell.self), for: indexPath) as! RecommendGoodsCell
            cell.goods = goodsList[indexPath.row]
            
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == typeCollectionView {
            currentCategory = categorys[indexPath.row]
            load()
        } else {
            let goodsDetialCtrl = GoodsDetialController.init(nibName: "GoodsDetialController", bundle: getBundle())
            goodsDetialCtrl.ID = goodsList[indexPath.row].goods_id
            goodsDetialCtrl.detialType = .detial
            navigationController?.pushViewController(goodsDetialCtrl, animated: true)
        }
    }
    
    
    
    
    
    
    
}













