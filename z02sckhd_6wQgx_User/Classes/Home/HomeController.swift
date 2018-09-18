//
//  HomeController.swift
//  TianMaUser
//
//  Created by YH_O on 2018/7/24.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import MJRefresh
import YHTool

public class HomeController: UIViewController {
    
    var rowHeight: CGFloat = 0
    let gap: CGFloat = 15
    var categorys = [CategoryInfo]()
    var auctionGoods = [SalesResult]()
    var groupGoods = [SalesResult]()
    var timelimitGoods = [SalesResult]()
    var recommendGoods = [Goods]()
    var newGoods = [Goods]()
    var shops = [HomeShop]()
    var banners = [String]()
    
    var sort = ""
    var order = ""
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isShowSearchBar(isShow: false)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isShowSearchBar(isShow: true)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        view.addSubview(collectionView)
        
        navigationController?.navigationBar.addSubview(searchBtn)
        load()
        collectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(load))
    }
    
    @objc func load() {
        loadHome()
        loadCategorys()
        loadAuction()
        loadGroup()
        loadTimelimit()
        loadRecommend()
        loadNewGoods()
    }
    /** 获取首页 */
    func loadHome() {
        getRequest(baseUrl: Home_URL, params: ["token" : Singleton.shared.token], success: { [weak self] (obj: HomeInfo) in
            if "success" == obj.status {
                self?.shops = (obj.data?.bestshop)!
                self?.bannerImgs(banners: (obj.data?.banner)!)
                self?.collectionView.reloadData()
            } else {
                self?.showAutoHideHUD(message: obj.msg!)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 获取分类 */
    func loadCategorys() {
        getRequest(baseUrl: GoodsCategory_URL, params: nil, success: { [weak self] (obj: GoodsCategory) in
            self?.collectionView.mj_header.endRefreshing()
            if "success" == obj.status {
                self?.categorys = obj.data
                self?.collectionView.reloadData()
            } else {
                self?.showAutoHideHUD(message: obj.msg!)
            }
        }) { (error) in
            self.collectionView.mj_header.endRefreshing()
            self.inspectError()
        }
    }
    /** 拍卖列表 */
    func loadAuction() {
        getRequest(baseUrl: GoodsAuction_URL, params: nil, success: { [weak self] (obj: SalesInfo) in
            if "success" == obj.status {
                self?.auctionGoods = (obj.data?.result)!
                self?.collectionView.reloadData()
            } else {
                self?.showAutoHideHUD(message: obj.msg!)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 团购列表 */
    func loadGroup() {
        getRequest(baseUrl: GoodsGroup_URL, params: nil, success: { [weak self] (obj: SalesInfo) in
            if "success" == obj.status {
                self?.groupGoods = (obj.data?.result)!
                self?.collectionView.reloadData()
            } else {
                self?.showAutoHideHUD(message: obj.msg!)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 秒杀列表 */
    func loadTimelimit() {
        getRequest(baseUrl: GoodsTimelimit_URL, params: nil, success: { [weak self] (obj: SalesInfo) in
            if "success" == obj.status {
                self?.timelimitGoods = (obj.data?.result)!
                self?.collectionView.reloadData()
            } else {
                self?.showAutoHideHUD(message: obj.msg!)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 推荐列表 */
    func loadRecommend() {
        getRequest(baseUrl: GoodsList_URL, params: ["token" : Singleton.shared.token, "p" : "1", "is_best" : "1"], success: { [weak self] (obj: DataInfo) in
            if "success" == obj.status {
                self?.recommendGoods = (obj.data?.result)!
                self?.collectionView.reloadData()
            } else {
                self?.showAutoHideHUD(message: obj.msg!)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 新品列表 */
    func loadNewGoods() {
        getRequest(baseUrl: GoodsList_URL, params: ["token" : Singleton.shared.token, "sort" : sort, "order" : order, "p" : "1"], success: { [weak self] (obj: DataInfo) in
            self?.collectionView.mj_header.endRefreshing()
            if "success" == obj.status {
                self?.newGoods = (obj.data?.result)!
                self?.collectionView.reloadData()
            } else {
                self?.showAutoHideHUD(message: obj.msg!)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** banner 图片 URL */
    private func bannerImgs(banners: [HomeBanner]) {
        var images = [String]()
        for banner in banners {
            images.append(banner.litpic)
        }
        self.banners = images
    }
    /** 获取行高 */
    private func getRowHeight(section: Int) -> CGFloat {
        
        let W = (WIDTH - gap * 3) / 2
        let commonH = gap
        var height = W + commonH + 60
        if section == 0 || section == 1 || section == 2 {
            height = W + commonH + 96
        } else if section == 5 {
            height = W / 2 + commonH + 35
        }
        return height
    }
    
    private func isShowSearchBar(isShow: Bool) {
        let alpha: CGFloat = isShow ? 1 : 0
        UIView.animate(withDuration: 0.2, animations: {
            self.searchBtn.alpha = alpha
        })
    }
    // MARK: - Callbacks
    @objc private func action_search() {
        
        isShowSearchBar(isShow: false)
        let searchCtrl = SearchController.init(nibName: "SearchController", bundle: getBundle())
        navigationController?.pushViewController(searchCtrl, animated: true)
    }
    
    private func callbacksSegment(header: SegmentReusableView) {
        header.clickItem = { [weak self] index in
            if index == 0 {
                self?.order = "asc"
            } else {
                self?.sort = "s.sales"
            }
            self?.loadNewGoods()
        }
    }
    
    private func callbacksHeader(header: HomeHeaderView) {
        header.clickItemBlock = { [weak self] index in
            let category = self?.categorys[index]
            let typeCtrl = SecondaryTypesController.init(nibName: "SecondaryTypesController", bundle: bundle(type(of: self) as! AnyClass))
            typeCtrl.pID = (category?.id)!
            self?.navigationController?.pushViewController(typeCtrl, animated: true)
        }
    }
    
    // MARK: - Getter
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        
        layout.itemSize = CGSize.init(width: (WIDTH - gap * 3) / 2, height: getRowHeight(section: -1))
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets.init(top: gap, left: gap, bottom: gap, right: gap)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: WIDTH, height: HEIGHT), collectionViewLayout:self.layout)
        view.register(UINib.init(nibName: CellName(TimelimitGoodsCell.self), bundle: getBundle()), forCellWithReuseIdentifier: CellName(TimelimitGoodsCell.self))
        view.register(UINib.init(nibName: CellName(RecommendGoodsCell.self), bundle: getBundle()), forCellWithReuseIdentifier: CellName(RecommendGoodsCell.self))
        view.register(UINib.init(nibName: CellName(MerchantCell.self), bundle: getBundle()), forCellWithReuseIdentifier: CellName(MerchantCell.self))
        
        view.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CellName(HomeHeaderView.self))
        view.register(UINib.init(nibName: CellName(SectionNormalReusableView.self), bundle: getBundle()), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CellName(SectionNormalReusableView.self))
        view.register(UINib.init(nibName: CellName(SegmentReusableView.self), bundle: getBundle()), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CellName(SegmentReusableView.self))
        view.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: TabBarH, right: 0)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private lazy var searchBtn: UIButton = {
        let height: CGFloat = 30
        let gap: CGFloat = 30
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: gap, y: (NavigationBarH - height - 20) / 2, width: WIDTH - gap * 2, height: height)
        btn.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        btn.setTitle("请输入宝贝名称", for: .normal)
        btn.setImage(getImage(type(of: self), "ico_img_ss"), for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)
        btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.titleLabel?.textColor = UIColor.darkText
        btn.layer.cornerRadius = height / 2
        btn.addTarget(self, action: #selector(action_search), for: .touchUpInside)
        
        return btn
    }()
}

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    // MARK: - UICollectionViewDataSource
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 6
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return auctionGoods.count
        case 1:
            return groupGoods.count
        case 2:
            return timelimitGoods.count
        case 3:
            return recommendGoods.count
        case 4:
            return newGoods.count
        case 5:
            return shops.count
        default: return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = indexPath.section
        
        if section == 0 || section == 1 || section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName(TimelimitGoodsCell.self), for: indexPath) as! TimelimitGoodsCell
            switch section {
            case 0:
                cell.type = .auction
                cell.result = auctionGoods[indexPath.row]
            case 1:
                cell.type = .groupBuy
                cell.result = groupGoods[indexPath.row]
            case 2:
                cell.type = .timelimit
                cell.result = timelimitGoods[indexPath.row]
            default: break
            }
            return cell
        } else if section == 3 || section == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName(RecommendGoodsCell.self), for: indexPath) as! RecommendGoodsCell
            
            cell.goods = section == 3 ? recommendGoods[indexPath.row] : newGoods[indexPath.row]
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName(MerchantCell.self), for: indexPath) as! MerchantCell
            cell.shop = shops[indexPath.row]
            
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: (WIDTH - gap * 3) / 2, height: getRowHeight(section: indexPath.section))
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = indexPath.section
        if section == 0 {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellName(HomeHeaderView.self), for: indexPath) as! HomeHeaderView
            callbacksHeader(header: headerView)
            headerView.images = banners
            headerView.categorys = categorys
            
            return headerView
        } else if section == 4 {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellName(SegmentReusableView.self), for: indexPath) as! SegmentReusableView
            callbacksSegment(header: headerView)
            
            return headerView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellName(SectionNormalReusableView.self), for: indexPath) as! SectionNormalReusableView
            headerView.homeSection = section
            
            return headerView
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var height: CGFloat = 60
        if section == 0 {
            let header = HomeHeaderView()
            height += header.bannerHeight + header.getItemHeight() * 2
        }
        return CGSize.init(width: WIDTH, height: height)
    }
    
    // MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isShowSearchBar(isShow: false)
        
        let section = indexPath.section
        var ID = ""
        var detialType: DetialType = .detial
        if section == 5 {
            let storeCtrl = StoreController.init(nibName: "StoreController", bundle: getBundle())
            storeCtrl.ID = shops[indexPath.row].id
            navigationController?.pushViewController(storeCtrl, animated: true)
            return
        } else if section == 0 {
            ID = auctionGoods[indexPath.row].act_id
            detialType = .auction
        } else if section == 1 {
            ID = groupGoods[indexPath.row].act_id
            detialType = .groupBuy
        } else if section == 2 {
            ID = timelimitGoods[indexPath.row].act_id
            detialType = .timelimit
        } else if section == 3 {
            ID = recommendGoods[indexPath.row].goods_id
        } else if section == 4 {
            ID = newGoods[indexPath.row].goods_id
        }
        
        let goodsDetialCtrl = GoodsDetialController.init(nibName: "GoodsDetialController", bundle: getBundle())
        goodsDetialCtrl.ID = ID
        goodsDetialCtrl.detialType = detialType
        navigationController?.pushViewController(goodsDetialCtrl, animated: true)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationController?.navigationBar.endEditing(true)
    }
    
    
    
}


