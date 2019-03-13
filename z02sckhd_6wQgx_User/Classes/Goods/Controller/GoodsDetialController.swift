//
//  GoodsDetialController.swift
//  TianMaUser
//
//  Created by Healson on 2018/7/27.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import MJRefresh
import YHTool
import TMSDK
import TMShare
import RongIMKit

enum DetialType {
    
    case detial
    case timelimit
    case groupBuy
    case auction
    case auctionSuccess
    
}

class GoodsDetialController: TMViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupbuyView: UIView!
    @IBOutlet weak var groupBuyPrice: UILabel!
    @IBOutlet weak var addCartBtn: UIButton!
    @IBOutlet weak var participate: UIButton!
    @IBOutlet weak var participativeNum: UILabel!
    @IBOutlet weak var auctionView: UIView!
    @IBOutlet weak var auctionPrice: UILabel!
    @IBOutlet weak var collectBtn: YHButton!
    @IBOutlet weak var auctionPay: UIButton!
    
    let bannerHeight: CGFloat = 280
    var goodsID = ""
    var specID = ""
    var number = 1
    var isBuy = false
    var detialType: DetialType = .detial

    var specificH: CGFloat = 0
    var shareUrl = ""
    
    var isPush = 0
    
    var goodsDetial: GoodsDetial?
    var salesDetial: SalesDetialData?
    var comments = [Comment]()
    var specs = [GoodsSpec]()
    var attrs = [GoodsAttr]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isTranslucent = true
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.navigationBar.barStyle = .default
//        navigationController?.navigationBar.isTranslucent = false
//        
//        
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if detialType != .auction || detialType != .auctionSuccess {
            view.addSubview(specificOption)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        specificH = detialType == .detial ? 100 : 0
        collectBtn.isHidden = detialType != .detial
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        footerSetup()
        callbacksWithSpecificView()
        navigationItem.leftBarButtonItem = UIBarButtonItem.itemBundle(bundle: getBundle(), image: "ico_img_fh1", target: self, action: #selector(action_back))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.itemBundle(bundle: getBundle(), image: "ico_img_fx", target: self, action: #selector(action_share))
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        tableView.register(UINib.init(nibName: CellName(DetialBaseInfoCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(DetialBaseInfoCell.self))
        tableView.register(UINib.init(nibName: CellName(SpecificCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(SpecificCell.self))
        tableView.register(UINib.init(nibName: CellName(TimelimitBaseInfoCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(TimelimitBaseInfoCell.self))
        tableView.register(UINib.init(nibName: CellName(AuctionBaseInfoCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(AuctionBaseInfoCell.self))
        tableView.register(UINib.init(nibName: CellName(GoodsCreditCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(GoodsCreditCell.self))
        tableView.register(UINib.init(nibName: CellName(GoodsEvaluateCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(GoodsEvaluateCell.self))
        tableView.register(UINib.init(nibName: CellName(GoodsDetialCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(GoodsDetialCell.self))
        tableView.register(UINib.init(nibName: CellName(AuctionRecordCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(AuctionRecordCell.self))
        
        tableView.tableHeaderView = carouselView
        loadDetial()
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadDetial))
        getShareUrl()
    }
    
    @objc func loadDetial() {
        switch detialType {
        case .auction:
            loadAuction()
        case .groupBuy:
            loadGroup()
        case .timelimit:
            loadTimelimit()
        case .detial:
            load()
        default: break
        }
    }
    
    private func footerSetup() {
        if detialType != .auction && detialType != .auctionSuccess {
            auctionView.isHidden = true
        }
        if detialType == .timelimit || detialType == .detial {
            groupbuyView.isHidden = true
            participate.isHidden = true
            participativeNum.isHidden = true
            if detialType == .timelimit {
                addCartBtn.isHidden = true
            }
        }
    }
    /** banner 图片 URL */
    private func bannerImgs(images: [GoodsImage]) {
        var banners = [String]()
        for image in images {
            banners.append(image.thumb)
        }
        carouselView.imgURLArr = banners
        loadComment()
    }
    /** 竞拍结果处理 */
    private func auctionResult() {
        auctionPrice.text = "¥\(Float((salesDetial?.store?.new_price ?? "0.00"))! + Float((salesDetial?.store?.markups ?? "0.00"))!)"
        if salesDetial?.is_top == 1 {
            auctionPay.setTitle("立即支付", for: .normal)
            auctionPrice.text = "¥\((salesDetial?.store?.new_price ?? "0.00")!)"
        } else if salesDetial?.store?.is_finished == 1 {
            auctionPay.isEnabled = false
            auctionPrice.text = "¥\((salesDetial?.store?.new_price ?? "0.00")!)"
        }
        tableView.reloadData()
    }
    /** 商品详情 */
    func load() {
        showHUD()
        getRequest(baseUrl: GoodsDetial_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "id" : goodsID], success: { [weak self] (obj: DetialInfo) in
            self?.hideHUD()
            self?.tableView.mj_header.endRefreshing()
            if "success" == obj.status {
                self?.goodsDetial = obj.data
                self?.specs = (obj.data?._specs)!
                self?.attrs = (obj.data?.attr)!
                self?.collectBtn.isSelected = (obj.data?.is_collect == 1) ? true : false
                self?.tableView.reloadData()
                if self?.goodsDetial?.grade == 1{
                    self?.addCartBtn.isHidden = true
                }
                self?.bannerImgs(images: (obj.data?._images)!)
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.tableView.mj_header.endRefreshing()
            self.inspectError()
        }
    }
    /** 竞拍详情 */
    func loadAuction() {
        let form = TMHttpUserInstance.sharedManager()?.member_id == 0 ? "100" : ""
        showHUD()
        getRequest(baseUrl: AuctionDetial_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "id" : goodsID, "form" : form], success: { [weak self] (obj: SalesDetialInfo) in
            self?.hideHUD()
            self?.tableView.mj_header.endRefreshing()
            if "success" == obj.status {
                self?.salesDetial = obj.data
                self?.goodsDetial = obj.data?.goods
                self?.specs = (obj.data?.goods?._specs_all)!
                self?.attrs = (obj.data?.goods?.attr)!
                self?.auctionResult()
                self?.bannerImgs(images: (obj.data?.goods?._images)!)
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.tableView.mj_header.endRefreshing()
            self.inspectError()
        }
    }
    /** 团购详情 */
    func loadGroup() {
        showHUD()
        getRequest(baseUrl: GroupDetial_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "id" : goodsID], success: { [weak self] (obj: SalesDetialInfo) in
            self?.hideHUD()
            self?.tableView.mj_header.endRefreshing()
            if "success" == obj.status {
                self?.salesDetial = obj.data
                self?.goodsDetial = obj.data?.goods
                self?.goodsDetial?.discount_price = obj.data?.store?.price ?? "0.00"
                self?.groupBuyPrice.text = "¥\(obj.data?.store?.price ?? "0.00")"
                self?.participativeNum.text = "当前已有\(obj.data?.onum ?? 0)人参团"
                self?.tableView.reloadData()
                self?.bannerImgs(images: (obj.data?.goods?._images)!)
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.tableView.mj_header.endRefreshing()
            self.inspectError()
        }
    }
    /** 秒杀详情 */
    func loadTimelimit() {
        showHUD()
        getRequest(baseUrl: TimelimitDetial_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "id" : goodsID], success: { [weak self] (obj: SalesDetialInfo) in
            self?.hideHUD()
            self?.tableView.mj_header.endRefreshing()
            if "success" == obj.status {
                self?.salesDetial = obj.data
                self?.goodsDetial = obj.data?.goods
                self?.goodsDetial?.discount_price = obj.data?.store?.price ?? "0.00"
                self?.tableView.reloadData()
                self?.bannerImgs(images: (obj.data?.goods?._images)!)
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.tableView.mj_header.endRefreshing()
            self.inspectError()
        }
    }
    /** 获取评论 */
    func loadComment() {
        getRequest(baseUrl: GoodsComment_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "id" : "\(goodsDetial?.goods_id ?? 0)", "page" : "1"], success: { [weak self] (obj: CommentInfo) in
            if "success" == obj.status {
                self?.comments = (obj.data?.result)!
                self?.tableView.reloadData()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 加入购物车 */
    func addCart() {
        showHUD()
        getRequest(baseUrl: AddCart_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "spec_id" : specID, "quantity" : "\(number)"], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.showAutoHideHUD(message: "添加成功！", completed: {
                    self?.specificOption.isShowOption(isShow: false, specificGap: (self?.specificH)!,isPush: (self?.isPush)!)
                })
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 收藏 */
    func addCollect(sender: UIButton) {
        showHUD()
        getRequest(baseUrl: AddCollect_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "id" : goodsID, "type" : "1"], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                sender.isSelected = true
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 取消收藏 */
    func cancelCollect(sender: UIButton) {
        showHUD()
        getRequest(baseUrl: CancelCollect_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "id" : goodsID], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                sender.isSelected = false
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
    }
    /** 分享地址 */
    func getShareUrl() {
        getRequest(baseUrl: Share_URL, params: ["from" : "1"], success: { [weak self] (obj: ShareUrl) in
            if "success" == obj.status {
                self?.shareUrl = obj.data
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 显示规格选项 */
    func showOptionView(isBuy: Bool) {
        specificOption.buyBtn.setTitle(isBuy ? "立即购买" : "立即添加", for: .normal)
        if detialType != .detial {
            specificOption.limitNum = "\((salesDetial?.store?.number)!)"
        }
        specificOption.goodsDetial = goodsDetial
        specificOption.isShowOption(isShow: true, specificGap: specificH,isPush: self.isPush)
        self.isBuy = isBuy
    }
    
    // MARK: - Callbacks
    func callbacks(cell: SpecificCell) {
        cell.clickItemBlock = { [weak self] (cell, index) in
//            let spec = self?.specs[index]
//            self?.specID = (spec?.spec_id)!
        }
    }
    
    func callbacksWithSpecificView() {
        specificOption.pay = { [weak self] (specID, num) in
            self?.number = num
            switch self?.detialType {
            case .detial?:
                if specID.isEmpty {
                    self?.showAutoHideHUD(message: "请选择商品规格！")
                } else {
                    self?.specID = specID
                    (self?.isBuy)! ? self?.goodsBuy() : self?.addCart()
                }
            case .groupBuy?:
                self?.groupBuy()
            case .timelimit?:
                self?.timelimitBuy()
            default: break
            }
        }
    }
    
    @objc func action_back() {
        if self.isPush == 1{
           self.dismiss(animated: true, completion: nil)
        }
        else{
            navigationController?.popViewController(animated: true)

        }
    }
    
    @objc func action_share() {
        if shareUrl.isEmpty {
            showAutoHideHUD(message: "对不起，暂时还不能分享哦！")
            return
        }
        TMShareInstance.sharedManager()?.showShare("\(BASE_URL)/z02sckhd_6wqgx/apigoods/h5/id/\(self.goodsID)/code/\(CODE)", thumbUrl: "", title: goodsDetial?.goods_name, descr: "下载APP得更多精彩礼品！", currentController: self, finish: { [weak self] (data, error) in
            if let shareError = error {
                self?.showAutoHideHUD(message: "分享失败")
            } else {
                self?.showAutoHideHUD(message: "分享成功")
            }
        })
    }
    
    @IBAction func action_store() {
        
        let storeCtrl = StoreController.init(nibName: "StoreController", bundle: getBundle())
        storeCtrl.ID = "\((goodsDetial?.sid)!)"
        navigationController?.pushViewController(storeCtrl, animated: true)
        
    }
    
    @IBAction func action_service() {
        
        let alertCtrl = UIAlertController.init(title: "请选择联系方式", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "联系客服", style: .default) { (action) in
            
            //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，群聊、聊天室为会话的ID）
            
            
            var parent: UIViewController?
            var navigation:UINavigationController?
            if let window = UIApplication.shared.delegate?.window,let rootVC = window?.rootViewController {
                parent = rootVC
                while (parent?.presentedViewController != nil) {
                    parent = parent?.presentedViewController!
                }
                
                if let tabbar = parent as? UITabBarController ,let nav = tabbar.selectedViewController as? UINavigationController {
                    navigation = nav
                }else if let nav = parent as? UINavigationController {
                    navigation = nav
                }
            }
            navigation?.setNavigationBarHidden(true, animated: true)
            
            let chat = ChatDDDDViewController()
            chat.conversationType = RCConversationType.ConversationType_PRIVATE
            chat.targetId = "s" + "\((self.goodsDetial?.sid)!)"
            chat.title = "联系客服"
            
            self.navigationController?.pushViewController(chat, animated: true)
            
//            let chat = RCConversationViewController.init(conversationType: RCConversationType.ConversationType_PRIVATE, targetId: "s" + "\((self.goodsDetial?.sid)!)")
//              chat?.conversationMessageCollectionView.frame = CGRect.init(x: 0, y: NavigationBarH, width: WIDTH, height: HEIGHT-200)
//            chat!.view.frame = CGRect.init(x: 0, y: 64, width: WIDTH, height: 300)
//            
//            chat!.view.backgroundColor = UIColor.red
//            chat!.chatSessionInputBarControl.backgroundColor = UIColor.red
//            chat!.chatSessionInputBarControl.containerView.backgroundColor = UIColor.green
//            chat!.chatSessionInputBarControl.frame = CGRect.init(x: 0, y: HEIGHT-200, width: WIDTH, height: 50)
          
//            chat!.extensionView.frame = CGRect.init(x: 0, y: NavigationBarH, width: WIDTH, height: HEIGHT-200)
           
           
//            let bar = RCChatSessionInputBarControl.init(frame: CGRect.init(x: 0, y: HEIGHT-200, width: WIDTH, height: 50), withContainerView: chat!.chatSessionInputBarControl.containerView, controlType: RCChatSessionInputBarControlType.defaultType, controlStyle: RCChatSessionInputBarControlStyle(rawValue: 0)!, defaultInputType: RCChatSessionInputBarInputType(rawValue: 0)!)
//            chat!.chatSessionInputBarControl = bar
            //
            //设置聊天会话界面要显示的标题
//            chat!.title = "联系客服"
//            //显示聊天会话界面
//            self.navigationController?.pushViewController(chat!, animated: true)
        }
        let sureAction = UIAlertAction.init(title: "拨打电话", style: .default) { (action) in
            if let phone = self.goodsDetial?.phone {
                let tel = "telprompt://" + phone
                let url = URL.init(string: tel)
                UIApplication.shared.openURL(url!)
                if phone.isEmpty {
                    self.showAutoHideHUD(message: "暂无服务号码！")
                }
            } else {
                self.showAutoHideHUD(message: "暂无服务号码！")
            }
        }
        alertCtrl.addAction(cancelAction)
        alertCtrl.addAction(sureAction)
        self.present(alertCtrl, animated: true, completion: nil)
       
    }
    
    @IBAction func action_collect(_ sender: UIButton) {
        if !inspectLogin() { return }
        if sender.isSelected {
            cancelCollect(sender: sender)
        } else {
            addCollect(sender: sender)
        }
    }
    
    @IBAction func action_add(_ sender: UIButton) {
        if !inspectLogin() { return }
        if self.goodsDetial?.grade == 0 {
            showOptionView(isBuy: false)
        }
        else{
            self.showAutoHideHUD(message: "虚拟商品不能加入购物车！")

        }
    }
    /** 立即购买 */
    @IBAction func action_buy(_ sender: UIButton) {
        if !inspectLogin() { return }
        if detialType == .auction {
            auctionBid()
        } else {
            showOptionView(isBuy: true)
        }
    }
    /** 竞争拍卖 */
    func auctionBid() {
        if salesDetial?.is_top == 1 {
            auctionBuy()
            return
        }
        showHUD()
        let newPrice = salesDetial?.store?.new_price ?? "0.00"
        let price = Float(newPrice.isEmpty ? "0.00" : newPrice)! + Float(salesDetial?.store?.markups ?? "0")!
        getRequest(baseUrl: AuctionBid_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "id" : goodsID, "price" : "\(price)"], success: { [weak self] (obj: AuctionBid) in
            self?.hideHUD()
            if "success" == obj.status {
                if obj.data?.is_top == 1 {
                    self?.auctionBuy()
                }
            } else {
                self?.inspectLogin(model: obj)
            }
            self?.loadAuction()
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
    }
    /** 拍卖购买 */
    func auctionBuy() {
        
        showHUD()
        getRequest(baseUrl: AuctionBuy_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "id" : goodsID, "price" : (salesDetial?.store?.maxprice)!], success: { [weak self] (obj: AuctionBid) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.submit(flowType: "2")
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
        
    }
    /** 团购购买 */
    func groupBuy() {
        
        showHUD()
        getRequest(baseUrl: GroupBuy_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "id" : goodsID, "quantity" : "\(number)"], success: { [weak self] (obj: AuctionBid) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.submit(flowType: "1")
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
        
    }
    /** 秒杀购买 */
    func timelimitBuy() {
        
        showHUD()
        getRequest(baseUrl: TimelimitBuy_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "id" : goodsID, "quantity" : "\(number)"], success: { [weak self] (obj: AuctionBid) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.submit(flowType: "4")
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
        
    }
    /** 商品购买 */
    func goodsBuy() {
        
        showHUD()
        getRequest(baseUrl: Buy_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "spec_id" : specID, "quantity" : "\(number)"], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.submit(flowType: "5")
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
        
    }
    /** 提交 */
    func submit(flowType: String) {
        
        getRequest(baseUrl: CartSubmit_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "flow_type" : flowType], success: { [weak self] (obj: CartOrderInfo) in
            if "success" == obj.status {
           
                if self?.goodsDetial?.grade == 1 {
                   let confirmOrder = XuNiConfirmOrderViewController.init(nibName: "XuNiConfirmOrderViewController", bundle: getBundle())
                    confirmOrder.flowType = flowType
                    confirmOrder.orderInfo = obj
                    self?.navigationController?.pushViewController(confirmOrder, animated: true)
                } else {
                    let confirmOrder = ConfirmOrderController.init(nibName: "ConfirmOrderController", bundle: getBundle())
                    confirmOrder.flowType = flowType
                    confirmOrder.orderInfo = obj
                    self?.navigationController?.pushViewController(confirmOrder, animated: true)
                }
                
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
        
    }
    
    // MARK: - Getter
    lazy var carouselView: YHScrollView = {
        
        let view = YHScrollView.init(frame: CGRect.init(x: 0, y: 0, width: WIDTH, height: bannerHeight), imageName: Banners())!
        view.currentIndicatorColor = UIColor.black
        view.otherIndicatorColor = UIColor.white
        let width: CGFloat = CGFloat((Banners()?.count)! * 20)
        let height: CGFloat = 30
        view.indicatorFrame = CGRect.init(x: WIDTH - width, y: bannerHeight - height, width: width, height: height)
        return view
        
    }()
    
    lazy var specificOption: SpecificOptionView = {
        
        let view = SpecificOptionView.specificOption() as! SpecificOptionView
        view.frame = CGRect.init(x: 0, y: HEIGHT, width: WIDTH, height: HEIGHT / 2 + specificH)
        return view
        
    }()
    
}

extension GoodsDetialController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSorce
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if detialType == .auction || detialType == .auctionSuccess {
            return 4
        }
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if detialType == .auction || detialType == .auctionSuccess {
            return section == 3 || section == 0 ? 1 : section == 1 ? (salesDetial?.auctionlog.count ?? 0) : comments.count
        }
//        return section == 2 ? 1 : section == 1 ? comments.count : detialType == .detial ? 3 : 1
        return section == 2 ? 1 : section == 1 ? comments.count : detialType == .detial ? 2 : 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard detialType == .auction || detialType == .auctionSuccess else {
            switch indexPath.section {
            case 0:
                if indexPath.row == 0 {
                    if detialType == .detial {
                        let cell = tableView.dequeueReusableCell(withIdentifier: CellName(DetialBaseInfoCell.self)) as! DetialBaseInfoCell
                        cell.goodsDetial = goodsDetial
                        
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: CellName(TimelimitBaseInfoCell.self)) as! TimelimitBaseInfoCell
                        cell.type = detialType
                        cell.result = salesDetial
                        
                        return cell
                    }
                } else {
                    if detialType == .detial && indexPath.row == 1 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: CellName(SpecificCell.self)) as! SpecificCell
                        callbacks(cell: cell)
                        cell.attrs = attrs
                        
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: CellName(GoodsCreditCell.self)) as! GoodsCreditCell
                        cell.goodsDetial = goodsDetial
                        
                        return cell
                    }
                }
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: CellName(GoodsEvaluateCell.self)) as! GoodsEvaluateCell
                cell.comment = comments[indexPath.row]
                
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: CellName(GoodsDetialCell.self)) as! GoodsDetialCell
                cell.detial = goodsDetial?.description
                
                return cell
            }
        }
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName(AuctionBaseInfoCell.self)) as! AuctionBaseInfoCell
            cell.result = salesDetial
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName(AuctionRecordCell.self)) as! AuctionRecordCell
            cell.log = salesDetial?.auctionlog[indexPath.row]
            cell.increase.text = "¥\(salesDetial?.store?.markups ?? "0.00")"
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName(GoodsEvaluateCell.self)) as! GoodsEvaluateCell
            cell.comment = comments[indexPath.row]
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName(GoodsDetialCell.self)) as! GoodsDetialCell
            cell.detial = goodsDetial?.description
            
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = EvaluateSectionHeader.evaluateHeader() as! EvaluateSectionHeader
        view.showAllBlock = { [weak self] in
            let allComments = AllCommentsController.init(nibName: "AllCommentsController", bundle: getBundle())
            allComments.comments = (self?.comments)!
            self?.navigationController?.pushViewController(allComments, animated: true)
        }
        view.number = comments.count
        if detialType == .auction || detialType == .auctionSuccess {
            switch section {
            case 1:
                if detialType == .auction || detialType == .auctionSuccess {
                    view.detial = salesDetial
                    view.sectionType = .auction
                }
            case 3:
                view.sectionType = .detial
            default: break
            }
        } else {
            if section == 2 {view.sectionType = .detial}
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 0 ? 0 : 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableView.rowHeight
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return (indexPath.section == 0 && indexPath.row == 1 && attrs.count == 0) ? 0 : tableView.rowHeight
        
    }
    
}










