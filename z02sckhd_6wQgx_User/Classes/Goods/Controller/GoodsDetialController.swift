//
//  GoodsDetialController.swift
//  TianMaUser
//
//  Created by Healson on 2018/7/27.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool
import TMSDK

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
    
    let bannerHeight: CGFloat = 280
    var ID = ""
    var specID = ""
    var detialType: DetialType = .detial
    
    var goodsDetial: GoodsDetial?
    var salesDetial: SalesDetialData?
    var comments = [Comment]()
    var specs = [GoodsSpec]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if detialType == .detial {
            view.addSubview(specificOption)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        navigationItem.leftBarButtonItem = UIBarButtonItem.itemBundle(bundle: getBundle(), image: "ico_img_fh1", target: self, action: #selector(action_back))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.itemBundle(bundle: getBundle(), image: "ico_img_fx", target: self, action: #selector(action_share))
        
        tableView.rowHeight = UITableViewAutomaticDimension
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
    /** 商品详情 */
    func load() {
        showHUD()
        getRequest(baseUrl: GoodsDetial_URL, params: ["id" : ID], success: { [weak self] (obj: DetialInfo) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.goodsDetial = obj.data
                self?.specs = (obj.data?._specs)!
                self?.collectBtn.isSelected = (obj.data?.collects == "1") ? true : false
                self?.tableView.reloadData()
                self?.bannerImgs(images: (obj.data?._images)!)
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 竞拍详情 */
    func loadAuction() {
        showHUD()
        getRequest(baseUrl: AuctionDetial_URL, params: ["token" : TMHttpUser.token() ?? "", "id" : ID], success: { [weak self] (obj: SalesDetialInfo) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.salesDetial = obj.data
                self?.goodsDetial = obj.data?.goods
                self?.auctionPrice.text = "¥\(Float((obj.data?.store?.price ?? "0.00"))! + Float((obj.data?.store?.markups ?? "0.00"))!)"
                self?.specs = (obj.data?.goods?._specs_all)!
                self?.tableView.reloadData()
                self?.bannerImgs(images: (obj.data?.goods?._images)!)
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 团购详情 */
    func loadGroup() {
        showHUD()
        getRequest(baseUrl: GroupDetial_URL, params: ["token" : TMHttpUser.token() ?? "", "id" : ID], success: { [weak self] (obj: SalesDetialInfo) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.salesDetial = obj.data
                self?.goodsDetial = obj.data?.goods
                self?.groupBuyPrice.text = "¥\(obj.data?.store?.price ?? "0.00")"
                self?.participativeNum.text = "当前已有\(obj.data?.store?.num ?? "0")人参团"
                self?.tableView.reloadData()
                self?.bannerImgs(images: (obj.data?.goods?._images)!)
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 秒杀详情 */
    func loadTimelimit() {
        showHUD()
        getRequest(baseUrl: TimelimitDetial_URL, params: ["token" : TMHttpUser.token() ?? "", "id" : ID], success: { [weak self] (obj: SalesDetialInfo) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.salesDetial = obj.data
                self?.goodsDetial = obj.data?.goods
                self?.tableView.reloadData()
                self?.bannerImgs(images: (obj.data?.goods?._images)!)
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    /** 获取评论 */
    func loadComment() {
        getRequest(baseUrl: GoodsComment_URL, params: ["token" : TMHttpUser.token() ?? "", "id" : (goodsDetial?.goods_id)!, "page" : "1"], success: { [weak self] (obj: CommentInfo) in
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
        getRequest(baseUrl: AddCart_URL, params: ["token" : TMHttpUser.token() ?? "", "spec_id" : specID, "quantity" : "1"], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.showAutoHideHUD(message: "加入成功")
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
        getRequest(baseUrl: AddCollect_URL, params: ["token" : "", "id" : ID, "type" : "1"], success: { [weak self] (obj: BaseModel) in
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
        getRequest(baseUrl: CancelCollect_URL, params: ["token" : TMHttpUser.token() ?? "", "id" : ID], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                sender.isSelected = false
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    
    // MARK: - Callbacks
    func callbacks(cell: SpecificCell) {
        cell.clickItemBlock = { [weak self] (cell, index) in
            let spec = self?.specs[index]
            self?.specID = (spec?.spec_id)!
        }
    }
    
    func callbacksWithSpecificView() {
        specificOption.pay = { [weak self] specIDs in
            self?.specID = specIDs
            self?.goodsBuy()
        }
    }
    
    @objc func action_back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func action_share() {
        
    }
    
    @IBAction func action_store() {
        let storeCtrl = StoreController.init(nibName: "StoreController", bundle: getBundle())
        storeCtrl.ID = (goodsDetial?.sid)!
        navigationController?.pushViewController(storeCtrl, animated: true)
    }
    
    @IBAction func action_service() {
        let phone = "telprompt://" + (goodsDetial?.phone)!
        let url = URL.init(string: phone)
        UIApplication.shared.openURL(url!)
    }
    
    @IBAction func action_collect(_ sender: UIButton) {
        if sender.isSelected {
            cancelCollect(sender: sender)
        } else {
            addCollect(sender: sender)
        }
    }
    
    @IBAction func action_add(_ sender: UIButton) {
        addCart()
    }
    /** 立即购买 */
    @IBAction func action_buy(_ sender: UIButton) {
        switch detialType {
        case .detial:
            specificOption.isShowOption(isShow: true)
        case .auction:
            auctionBid()
        case .groupBuy:
            groupBuy()
        case .timelimit:
            timelimitBuy()
        default: break
        }
    }
    /** 竞争拍卖 */
    func auctionBid() {
        showHUD()
        let price = Float(salesDetial?.store?.new_price ?? "0.00")! + Float(salesDetial?.store?.markups ?? "0.00")!
        getRequest(baseUrl: AuctionBid_URL, params: ["token" : TMHttpUser.token() ?? "", "id" : ID, "price" : "\(price)"], success: { [weak self] (obj: AuctionBid) in
            self?.hideHUD()
            if "success" == obj.status {
                if "ok" == obj.data {
                    self?.auctionBuy()
                } else {
                    self?.salesDetial?.store?.new_price = obj.data
                    self?.tableView.reloadData()
                }
            } else {
                self?.inspectLogin(model: obj)
                if "over" == obj.data {
                    self?.salesDetial?.store?.is_end = true
                    self?.tableView.reloadData()
                }
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
    }
    /** 拍卖购买 */
    func auctionBuy() {
        showHUD()
        getRequest(baseUrl: AuctionBuy_URL, params: ["token" : TMHttpUser.token() ?? "", "id" : ID, "price" : (salesDetial?.store?.maxprice)!], success: { [weak self] (obj: AuctionBid) in
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
        getRequest(baseUrl: GroupBuy_URL, params: ["token" : TMHttpUser.token() ?? "", "id" : ID, "quantity" : "1"], success: { [weak self] (obj: AuctionBid) in
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
        getRequest(baseUrl: TimelimitBuy_URL, params: ["token" : TMHttpUser.token() ?? "", "id" : ID, "quantity" : "1"], success: { [weak self] (obj: AuctionBid) in
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
        getRequest(baseUrl: Buy_URL, params: ["token" : TMHttpUser.token() ?? "", "spec_id" : specID, "quantity" : "1"], success: { [weak self] (obj: BaseModel) in
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
        getRequest(baseUrl: CartSubmit_URL, params: ["token" : TMHttpUser.token() ?? "", "flow_type" : flowType], success: { [weak self] (obj: CartOrderInfo) in
            if "success" == obj.status {
                let confirmOrder = ConfirmOrderController.init(nibName: "ConfirmOrderController", bundle: getBundle())
                confirmOrder.flowType = flowType
                confirmOrder.orderInfo = obj
                self?.navigationController?.pushViewController(confirmOrder, animated: true)
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
        view.frame = CGRect.init(x: 0, y: HEIGHT, width: WIDTH, height: HEIGHT / 2 + 120)
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
            return section == 3 || section == 0 ? 1 : section == 1 ? 2 : comments.count
        }
        return section == 2 ? 1 : section == 1 ? comments.count : detialType == .detial ? 3 : 1
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
                        cell.specs = specs
                        
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
        if detialType == .auction || detialType == .auctionSuccess {
            switch section {
            case 1:
                if detialType == .auction || detialType == .auctionSuccess {
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
    
}










