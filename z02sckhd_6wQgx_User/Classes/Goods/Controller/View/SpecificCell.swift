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
        
        layout.itemSize = CGSize.init(width: 70, height: 25)
        
        collectionView.register(UINib.init(nibName: CellName(GoodsParameterCell.self), bundle: bundle(type(of: self))), forCellWithReuseIdentifier: CellName(GoodsParameterCell.self))
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Setter
    var specs = [GoodsSpec]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override var frame: CGRect {
        didSet {
            let y: CGFloat = 6
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
        return specs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName(GoodsParameterCell.self), for: indexPath) as! GoodsParameterCell
        let spec = specs[indexPath.row]
        cell.title.setTitle(spec.spec_1 + spec.spec_2, for: .normal)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let click = clickItemBlock {
            click(self, indexPath.row)
        }
    }
    
    
}







