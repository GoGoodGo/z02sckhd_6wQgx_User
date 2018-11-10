//
//  PaySuccessController.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/1.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool
import MJRefresh

class PaySuccessController: UIViewController {
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var checkOrder: UIButton!
    
    let gap: CGFloat = 15
    var page = 1
    var totalPage = 1
    var recommendGoods = [Goods]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "支付完成"
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        checkOrder.layer.borderColor = HexString("#d3d3d3").cgColor
        layout.sectionInset = UIEdgeInsets.init(top: gap, left: gap, bottom: gap, right: gap)
        let width = (WIDTH - gap * 3) / 2
        let height = width + gap + 60
        layout.itemSize = CGSize.init(width: width, height: height)
        
        collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        collectionView.register(UINib.init(nibName: CellName(RecommendGoodsCell.self), bundle: getBundle()), forCellWithReuseIdentifier: CellName(RecommendGoodsCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        
        load()
    }
    /** 获取推荐商品 */
    func load() {
        getRequest(baseUrl: GoodsList_URL, params: ["p" : "1", "is_best" : "1"], success: { [weak self] (obj: DataInfo) in
            if "success" == obj.status {
                self?.totalPage = (obj.data?.totalpage)!
                self?.recommendGoods = (obj.data?.result)!
                self?.collectionView.reloadData()
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.inspectError()
        }
    }
    
    /** 获取更多 */
    @objc func loadMore() {
        getRequest(baseUrl: GoodsList_URL, params: ["p" : "\(page)", "is_best" : "1"], success: { [weak self] (obj: DataInfo) in
            self?.collectionView.mj_footer.endRefreshing()
            if "success" == obj.status {
                self?.recommendGoods += (obj.data?.result)!
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
        collectionView.mj_footer.isHidden = (recommendGoods.count == 0)
        if page >= totalPage {
            collectionView.mj_footer.endRefreshingWithNoMoreData()
        } else {
            collectionView.mj_footer.endRefreshing()
        }
    }
    
    // MARK: - Callbacks
    @IBAction func action_checkOrder() {
        
    }
    
    @IBAction func action_backHome() {
        navigationController?.popToRootViewController(animated: true)
    }
    
}

extension PaySuccessController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        checkFooterState()
        return recommendGoods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName(RecommendGoodsCell.self), for: indexPath) as! RecommendGoodsCell
        cell.goods = recommendGoods[indexPath.row]
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let goodsDetialCtrl = GoodsDetialController.init(nibName: "GoodsDetialController", bundle: getBundle())
        goodsDetialCtrl.goodsID = "\(recommendGoods[indexPath.row].goods_id)"
        goodsDetialCtrl.detialType = .detial
        navigationController?.pushViewController(goodsDetialCtrl, animated: true)
    }
    
    
    
}









