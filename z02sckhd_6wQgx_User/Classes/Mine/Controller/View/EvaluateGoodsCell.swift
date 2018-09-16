//
//  EvaluateGoodsCell.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/7.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import Kingfisher
import YHTool

class EvaluateGoodsCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var textView: YHTextView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var addImage: ((_ cell: EvaluateGoodsCell) -> Void)?
    var delImage: ((_ cell: EvaluateGoodsCell, _ index: Int) -> Void)?
    var commentBlock: ((_ text: String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
    
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        textView.placeholder = "请输入商品评价"
        textView.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: CellName(GoodsImgCell.self), bundle: nil), forCellWithReuseIdentifier: CellName(GoodsImgCell.self))
        collectionView.register(UINib.init(nibName: CellName(AddImageCell.self), bundle: nil), forCellWithReuseIdentifier: CellName(AddImageCell.self))
    }
    
    // MARK: - Setter
    var goods: NotEvaluateGoods? {
        didSet {
            let url = URL(string: (goods?.goods_image)!)
            img.kf.setImage(with: url)
            name.text = goods?.goods_name
        }
    }
    
    var images = [UIImage]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override var frame: CGRect {
        didSet {
            let y:CGFloat = 10
            var tempFrame = frame
            tempFrame.origin.y += y
            tempFrame.size.height -= y
            super.frame = tempFrame
        }
    }
    
}

extension EvaluateGoodsCell: UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == images.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName(AddImageCell.self), for: indexPath) as! AddImageCell
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName(GoodsImgCell.self), for: indexPath) as! GoodsImgCell
            cell.img.image = images[indexPath.row]
            
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == images.count {
            if let click = addImage {
                click(self)
            }
        } else {
            if let click = delImage {
                click(self, indexPath.row)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        endEditing(true)
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidEndEditing(_ textView: UITextView) {
        if let click = commentBlock {
            click(textView.text)
        }
    }
    
    
    
    
    
    
}








