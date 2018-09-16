//
//  GoodsEvaluateCell.swift
//  TianMaUser
//
//  Created by YH_O on 2018/7/28.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool

class GoodsEvaluateCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var evaluate: UILabel!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionViewH: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var reply: UIButton!
    
    let gap: CGFloat = 13
    
    var clickItemBlock: ((_ cell: GoodsEvaluateCell, _ index: Int) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - PrivateMethod
    private func setupUI() {
        
        let width = (WIDTH - gap * 3 - 30) / 4
        layout.itemSize = CGSize.init(width: width, height: width)
        collectionViewH.constant = width + gap
        
        collectionView.register(UINib.init(nibName: CellName(EvaluateImageCell.self), bundle: nil), forCellWithReuseIdentifier: CellName(EvaluateImageCell.self))
        
        collectionView.contentInset = UIEdgeInsets.init(top: gap, left: 0, bottom: 0, right: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Setter
    var comment: Comment? {
        didSet {
            name.text = comment?.member_name
            date.text = comment?.add_time
            evaluate.text = comment?.comment
            collectionView.reloadData()
        }
    }
    
}

extension GoodsEvaluateCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (comment?.images.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName(EvaluateImageCell.self), for: indexPath) as! EvaluateImageCell
        cell.commentImage = comment?.images[indexPath.row]
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let click = clickItemBlock {
            click(self, indexPath.row)
        }
    }
    
    
    
    
    
    
    
}











