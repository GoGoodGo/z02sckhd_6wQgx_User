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
import SetI001
import RongIMKit

public class HomeController: TMViewController {
    
    var rowHeight: CGFloat = 0
    let gap: CGFloat = 15
    var headerView: HomeHeaderView?
    var categorys = [CategoryInfo]()
    var auctionGoods = [SalesResult]()
    var groupGoods = [SalesResult]()
    var timelimitGoods = [SalesResult]()
    var recommendGoods = [Goods]()
    var newGoods = [Goods]()
    var shops = [HomeShop]()
    var banners = [String]()
    var banner_Models = [HomeBanner]()

    var sort = ""
    var order = ""
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(login(notifi:)), name: NSNotification.Name(rawValue: "login"), object: nil)
        
        
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
//        isShowSearchBar(isShow: false)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
//        isShowSearchBar(isShow: true)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        
        let _ = SingleInstance.defaultSingleInstance()
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
       
        
        
        setupUI()
        self.loadUserDetial()
    }
    
    
    
    func loginRongYun(str:String){
        RCIM.shared()?.connect(withToken: str, success: { (userId) in
            print("登录成功-----token:\(userId ?? "")")
           
//            self.showAutoHideHUD(message: "融云链接成功")

            
        }, error: { (status) in
//            self.showAutoHideHUD(message: "融云链接失败")

        }, tokenIncorrect: {
//            self.showAutoHideHUD(message: "融云链接失败")

        })
    }
    //
    
    func loadUserDetial() {
        getRequest(baseUrl: UserDetial_URL, params: ["token" : TMHttpUser.token() ?? TestToken], success: { [weak self] (obj: UserInfo) in
            if "success" == obj.status {
//                Singleton.shared.rongyun_token =
                self?.loginRongYun(str: (obj.data?.rongyun_token)!)
                CODE = (obj.data?.code)!
            }
        }) { (error) in
            self.inspectError()
        }
    }
    
    
    
    // MARK: - Private Method
    private func setupUI() {
        
        view.addSubview(collectionView)
        
//        navigationController?.navigationBar.addSubview(searchBtn)
        load()
        collectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(load))
    }
    
    @objc func load() {
        loadHome()
        loadNewGoods()
    }
    /** 获取首页 */
    func loadHome() {
        showHUD()
        getRequest(baseUrl: Home_URL, params: ["token" : TMHttpUser.token() ?? TestToken], success: { [weak self] (obj: HomeInfo) in
            self?.hideHUD()
            self?.collectionView.mj_header.endRefreshing()
            if "success" == obj.status {
               
                
        
                
                self?.categorys = (obj.data?.category)!
                self?.auctionGoods = (obj.data?.auction)!
                self?.groupGoods = (obj.data?.groupbuy)!
                self?.timelimitGoods = (obj.data?.spike)!
                self?.recommendGoods = (obj.data?.isbest)!
                self?.shops = (obj.data?.bestshop)!
                self?.bannerImgs(banners: (obj.data?.banner)!)
                self?.collectionView.reloadData()
                self?.collectionView.performBatchUpdates({
                    self?.collectionView.setCollectionViewLayout((self?.layout)!, animated: true)
                }, completion: nil)
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.collectionView.mj_header.endRefreshing()
            self.inspectError()
        }
    }
   
    /** 新品列表 */
    func loadNewGoods() {
        getRequest(baseUrl: GoodsList_URL, params: ["sort" : sort, "order" : order, "p" : "1","token" : TMHttpUser.token() ?? TestToken], success: { [weak self] (obj: DataInfo) in
            self?.hideHUD()
            self?.hideAllHUD()
            self?.collectionView.mj_header.endRefreshing()
            if "success" == obj.status {
                self?.newGoods = (obj.data?.result)!
                self?.collectionView.reloadData()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.hideAllHUD()
            self.inspectError()
        }
    }
    /** banner 图片 URL */
    private func bannerImgs(banners: [HomeBanner]) {
        var images = [String]()
        for banner in banners {
            images.append(banner.litpic)
        }
        self.banner_Models = banners
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
        if isShow {
            searchBtn.isHidden = !isShow
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.searchBtn.alpha = alpha
        }) { (isCompletion) in
            self.searchBtn.isHidden = (alpha == 0)
        }
    }
    // MARK: - Callbacks
    @objc private func action_search() {
        
//        isShowSearchBar(isShow: false)
        let searchCtrl = SearchController.init(nibName: "SearchController", bundle: getBundle())
        navigationController?.pushViewController(searchCtrl, animated: true)
    }
    
    private func callbacksSegment(header: SegmentReusableView) {
        header.clickItem = { [weak self] index in
            if index == 0 {
                self?.sort = ""
                self?.order = "desc"
            } else {
                self?.sort = "s.sales"
            }
            self?.loadNewGoods()
        }
    }
    
    private func callbacksHeader(header: HomeHeaderView) {
        header.clickItemBlock = { [weak self] index in
            let category = self?.categorys[index]
            let typeCtrl = SecondaryTypesController.init(nibName: "SecondaryTypesController", bundle: getBundle())
            typeCtrl.pID = "\((category?.id)!)"
            typeCtrl.title = "\((category?.name)!)"
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
        
        view.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellName(HomeHeaderView.self))
        view.register(UINib.init(nibName: CellName(SectionNormalReusableView.self), bundle: getBundle()), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellName(SectionNormalReusableView.self))
        view.register(UINib.init(nibName: CellName(SegmentReusableView.self), bundle: getBundle()), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellName(SegmentReusableView.self))
        view.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: TabBarH + NavigationBarH, right: 0)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private lazy var searchBtn: UIButton = {
        let height: CGFloat = 30
        let gap: CGFloat = 30
        let btn = UIButton.init(type: .custom)
//        btn.frame = CGRect.init(x: gap, y: (NavigationBarH - height - 20) / 2, width: WIDTH - gap * 2, height: height)
        btn.frame = CGRect.init(x: gap, y: height - 2, width: WIDTH - gap * 2, height: height)
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.2)
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
            headerView.top_clickItemBlock = {[weak self](index) in
                if self?.banner_Models[index].type == "goods" {
                    let goodsDetialCtrl = GoodsDetialController.init(nibName: "GoodsDetialController", bundle: getBundle())
                    goodsDetialCtrl.goodsID = (self?.banner_Models[index].url)!
                    goodsDetialCtrl.detialType = DetialType.detial
                    self?.navigationController?.pushViewController(goodsDetialCtrl, animated: true)
                }
                else{
                    let webView = WebViewController()
                    webView.url = (self?.banner_Models[index].url)!
                    self?.navigationController?.pushViewController(webView, animated: true)
                    print("链接")
                }
            }
            self.headerView = headerView
            headerView.images = banners
            headerView.categorys = categorys
            headerView.addSubview(searchBtn)
            
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
        let sectionH: CGFloat = 60
        var height: CGFloat = 60
        switch section {
        case 0:
            height += headerView?.getHeaderHeight(isAution: auctionGoods.count != 0) ?? 0.0
        case 1:
            height = groupGoods.count == 0 ? -35.0 : sectionH
        case 2:
            height = timelimitGoods.count == 0 ? -35.0 : sectionH
        case 3:
            height = recommendGoods.count == 0 ? 0.0 : sectionH
        case 4:
            height = newGoods.count == 0 ? 0.0 : sectionH
        case 5:
            height = shops.count == 0 ? 0.0 : sectionH
        default: height = 0.01
        }
        return CGSize.init(width: WIDTH, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.init(width: 0, height: 0)
    }
    
    // MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        isShowSearchBar(isShow: false)
        
        let section = indexPath.section
        var ID = ""
        var detialType: DetialType = .detial
        if section == 5 {
            let storeCtrl = StoreController.init(nibName: "StoreController", bundle: getBundle())
            storeCtrl.ID = "\(shops[indexPath.row].id)"
            navigationController?.pushViewController(storeCtrl, animated: true)
            return
        } else if section == 0 {
            ID = "\(auctionGoods[indexPath.row].act_id)"
            detialType = .auction
        } else if section == 1 {
            ID = "\(groupGoods[indexPath.row].act_id)"
            detialType = .groupBuy
        } else if section == 2 {
            ID = "\(timelimitGoods[indexPath.row].act_id)"
            detialType = .timelimit
        } else if section == 3 {
            ID = "\(recommendGoods[indexPath.row].goods_id)"
        } else if section == 4 {
            ID = "\(newGoods[indexPath.row].goods_id)"
        }
        let goodsDetialCtrl = GoodsDetialController.init(nibName: "GoodsDetialController", bundle: getBundle())
        goodsDetialCtrl.goodsID = ID
        goodsDetialCtrl.detialType = detialType
        navigationController?.pushViewController(goodsDetialCtrl, animated: true)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationController?.navigationBar.endEditing(true)
    }
    
    
    
}


