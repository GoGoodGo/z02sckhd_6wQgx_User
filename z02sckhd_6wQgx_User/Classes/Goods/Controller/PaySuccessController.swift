//
//  PaySuccessController.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/1.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool

class PaySuccessController: UIViewController {
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var checkOrder: UIButton!
    
    let gap: CGFloat = 15
    
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
        
        collectionView.register(UINib.init(nibName: CellName(RecommendGoodsCell.self), bundle: nil), forCellWithReuseIdentifier: CellName(RecommendGoodsCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
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
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName(RecommendGoodsCell.self), for: indexPath) as! RecommendGoodsCell
        
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let goodsDetialCtrl = GoodsDetialController()
        navigationController?.pushViewController(goodsDetialCtrl, animated: true)
    }
    
    
    
}









