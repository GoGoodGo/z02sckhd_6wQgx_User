//
//  SpecificCell.swift
//  TianMaUser
//
//  Created by YH_O on 2018/8/18.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool

class SpecificCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    var clickItemBlock: ((_ cell: SpecificCell, _ index: Int) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
    
        setupUI()
    }
    
    // MARK: - PrivateMethod
    private func setupUI() {
        
        layout.itemSize = CGSize.init(width: (WIDTH - 30) / 3, height: 20)
        
        collectionView.register(UINib.init(nibName: CellName(GoodsAttrsCell.self), bundle: getBundle()), forCellWithReuseIdentifier: CellName(GoodsAttrsCell.self))
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Setter
    var attrs = [GoodsAttr]() {
        didSet {
            collectionView.isHidden = attrs.count == 0
            collectionView.reloadData()
        }
    }
    
    override var frame: CGRect {
        didSet {
            let y: CGFloat = attrs.count == 0 ? 0 : 10
            var tempFrame = frame
            tempFrame.origin.y += y
            tempFrame.size.height -= y
            super.frame = tempFrame
        }
    }
}

extension SpecificCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attrs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName(GoodsAttrsCell.self), for: indexPath) as! GoodsAttrsCell
        let attr = attrs[indexPath.row]
        cell.attrs.text = attr.attr_name + "：" + attr.value
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let click = clickItemBlock {
            click(self, indexPath.row)
        }
    }
    
    
}







