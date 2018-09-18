//
//  StoreController.swift
//  TianMaUser
//
//  Created by Healson on 2018/7/30.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import MJRefresh
import Kingfisher
import YHTool

class StoreController: UIViewController {
    
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var collect: UIButton!
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var ID = ""
    var order = ""
    var sort = ""
    var page = 1
    var totalPage = 1
    var cateID = ""
    let gap: CGFloat = 15
    var shopData: ShopData?
    var recommends = [Goods]()
    var goodsList = [Goods]()
    let titles = ["暂无", "暂无", "暂无", "暂无"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "商铺"
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.item(title: "搜索", target: self, action: #selector(action_search))
        
        imgView.layer.borderColor = UIColor.white.cgColor
        collect.layer.borderColor = UIColor.white.cgColor
        
        optionView.addSubview(segmentView)
        
        let width = (WIDTH - gap * 3) / 2
        let height = width + gap + 60
        layout.itemSize = CGSize.init(width: width, height: height)
        layout.sectionInset = UIEdgeInsets.init(top: gap, left: gap, bottom: gap, right: gap)
        
        collectionView.register(UINib.init(nibName: CellName(RecommendGoodsCell.self), bundle: getBundle()), forCellWithReuseIdentifier: CellName(RecommendGoodsCell.self))
        collectionView.register(UINib.init(nibName: CellName(SectionHeaderReusableView.self), bundle: getBundle()), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: SectionHeaderReusableView.self))
        collectionView.register(UINib.init(nibName: CellName(SegmentReusableView.self), bundle: getBundle()), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: SegmentReusableView.self))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        callbacksSegmentView()
        collectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(load))
        collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreNews))
        load()
    }
    /** 商铺详情 */
    @objc func load() {
        showHUD()
        getRequest(baseUrl: ShopDetial_URL, params: ["token" : Singleton.shared.token, "sid" : ID], success: { [weak self] (obj: ShopInfo) in
            self?.hideHUD()
            self?.collectionView.mj_header.endRefreshing()
            if "success" == obj.status {
                self?.shopData = obj.data
                self?.setupCategory()
                self?.loadBest()
                self?.loadNews()
            } else {
                self?.showAutoHideHUD(message: obj.msg!)
            }
        }) { (error) in
            self.hideHUD()
            self.collectionView.mj_header.endRefreshing()
            self.inspectError()
        }
    }
    /** 获取推荐 */
    func loadBest() {
        showHUD()
        getRequest(baseUrl: GoodsList_URL, params: ["token" : Singleton.shared.token, "cate_id" : cateID, "sid" : ID, "p" : "1", "is_best" : "1"], success: { [weak self] (obj: DataInfo) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.recommends = (obj.data?.result)!
                self?.collectionView.reloadData()
            } else {
                self?.showAutoHideHUD(message: obj.msg!)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
    }
    /** 获取新品 */
    func loadNews() {
        showHUD()
        getRequest(baseUrl: GoodsList_URL, params: ["token" : Singleton.shared.token, "sort" : sort, "order" : order, "cate_id" : cateID, "sid" : ID, "p" : "1"], success: { [weak self] (obj: DataInfo) in
            self?.hideAllHUD()
            self?.collectionView.mj_header.endRefreshing()
            if "success" == obj.status {
                self?.goodsList = (obj.data?.result)!
                self?.totalPage = (obj.data?.totalpage)!
                self?.page += 1
                self?.collectionView.reloadData()
            } else {
                self?.showAutoHideHUD(message: obj.msg!)
            }
        }) { (error) in
            self.collectionView.mj_header.endRefreshing()
            self.hideAllHUD()
            self.inspectError()
        }
    }
    /** 获取更多 */
    @objc func loadMoreNews() {
        getRequest(baseUrl: GoodsList_URL, params: ["token" : Singleton.shared.token, "sort" : sort, "order" : order, "cate_id" : cateID, "sid" : ID, "p" : "\(page)"], success: { [weak self] (obj: DataInfo) in
            self?.collectionView.mj_footer.endRefreshing()
            if "success" == obj.status {
                self?.goodsList += (obj.data?.result)!
                self?.page += 1
                self?.collectionView.reloadData()
            } else {
                self?.showAutoHideHUD(message: obj.msg!)
            }
        }) { (error) in
            self.collectionView.mj_footer.endRefreshing()
            self.inspectError()
        }
    }
    /** 收藏 */
    func addCollect(sender: UIButton) {
        showHUD()
        getRequest(baseUrl: AddCollect_URL, params: ["token" : Singleton.shared.token, "id" : ID, "type" : "2"], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                sender.isSelected = true
            } else {
                self?.inspect(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 取消收藏 */
    func cancelCollect(sender: UIButton) {
        showHUD()
        getRequest(baseUrl: CancelCollect_URL, params: ["token" : Singleton.shared.token, "id" : ID], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                sender.isSelected = false
            } else {
                self?.inspect(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 设置分类及初始化数据 */
    func setupCategory() {
        cateID = (shopData?.category.first?.id)!
        collect.isSelected = ((shopData?.seller?.is_collect) != 0)
        let url = URL(string: (shopData?.seller?.logo)!)
        imgView.kf.setImage(with: url)
        
        var names = [String]()
        for category in (shopData?.category)! {
            names.append(category.name)
        }
        segmentView.titles = names
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
    @objc private func action_search() {
        navigationController?.navigationBar.endEditing(true)
        
    }
    
    @IBAction func action_collect(_ sender: UIButton) {
        if sender.isSelected {
            cancelCollect(sender: sender)
        } else {
            addCollect(sender: sender)
        }
    }
    
    func callbacksSegmentView() {
        segmentView.clickItemBlock = { [weak self] index in
            self?.cateID = (self?.shopData?.category[index].id)!
            self?.loadBest()
            self?.loadNews()
        }
    }
    
    private func callbacksSegment(header: SegmentReusableView) {
        header.clickItem = { [weak self] index in
            if index == 0 {
                self?.order = "asc"
            } else {
                self?.sort = "s.sales"
            }
            self?.loadNews()
        }
    }
    
    private lazy var segmentView: YHSegmentView = {
        
        let view = YHSegmentView.init(frame: CGRect.init(x: 0, y: 0, width: WIDTH, height: 30), titles: self.titles)
        view.normalColor = UIColor.white
        view.background = UIColor.clear
        view.separatorColor = UIColor.clear
        view.itemW = 50
        return view
    }()

}

extension StoreController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        checkFooterState()
        return section == 0 ? recommends.count : goodsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName(RecommendGoodsCell.self), for: indexPath) as! RecommendGoodsCell
        cell.goods = indexPath.section == 0 ? recommends[indexPath.row] : goodsList[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 0 {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellName(SectionHeaderReusableView.self), for: indexPath) as! SectionHeaderReusableView
            headerView.imageUrl = shopData?.seller?.banner
            
            return headerView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellName(SegmentReusableView.self), for: indexPath) as! SegmentReusableView
            callbacksSegment(header: headerView)
            
            return headerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var height: CGFloat = 60
        if section == 0 {
            height += bannerH
        }
        return CGSize.init(width: WIDTH, height: height)
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let goodsDetialCtrl = GoodsDetialController.init(nibName: "GoodsDetialController", bundle: getBundle())
        goodsDetialCtrl.ID = indexPath.section == 0 ? recommends[indexPath.row].goods_id : goodsList[indexPath.row].goods_id
        navigationController?.pushViewController(goodsDetialCtrl, animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    
}









