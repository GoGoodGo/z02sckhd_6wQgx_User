//
//  GoodsEvaluateCell.swift
//  TianMaUser
//
//  Created by YH_O on 2018/7/28.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool

enum EvaluateType {
    case detial
    case all
}

class GoodsEvaluateCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var evaluate: UILabel!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionViewH: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var reply: UIButton!
    @IBOutlet weak var replyH: NSLayoutConstraint!
    @IBOutlet weak var top: UIImageView!
    @IBOutlet weak var bottom: UIImageView!
    
    let gap: CGFloat = 10
    var itemW: CGFloat = 0.00
    
    var clickItemBlock: ((_ cell: GoodsEvaluateCell, _ index: Int, _ images: [UIImage]) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - PrivateMethod
    private func setupUI() {
        
        itemW = (WIDTH - gap * 3 - 30) / 4
        layout.itemSize = CGSize.init(width: itemW, height: itemW)
        collectionViewH.constant = 0
        collectionView.register(UINib.init(nibName: CellName(EvaluateImageCell.self), bundle: getBundle()), forCellWithReuseIdentifier: CellName(EvaluateImageCell.self))
        
        collectionView.contentInset = UIEdgeInsets.init(top: gap, left: 0, bottom: 0, right: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Setter
    var type: EvaluateType = .detial {
        didSet {
            top.isHidden = type == .detial ? false : true
            bottom.isHidden = type == .all ? false : true
        }
    }
    
    func getReplyHeight() {
        reply.isHidden = comment?.reply_status == 0
        let size = comment?.reply_comment.textSize(font: UIFont.systemFont(ofSize: 14), maxSize: CGSize.init(width: WIDTH - 50, height: 120))
        replyH.constant = comment?.reply_status == 0 ? 0 : (size?.height ?? 0.0) + 10
    }
    
    var comment: Comment? {
        didSet {
            name.text = comment?.member_name
            date.text = comment?.add_time
            evaluate.text = comment?.comment
            getReplyHeight()
            let attriStr = NSAttributedString.init(string: "掌柜回复：" + (comment?.reply_comment ?? ""))
            reply.setAttributedTitle(attriStr, for: .normal)
            collectionViewH.constant = (comment?.images.count ?? 0) > 0 ? itemW + gap * 2 : 0
            collectionView.reloadData()
            collectionView.performBatchUpdates({
                self.collectionView.setCollectionViewLayout((self.layout)!, animated: true)
            }, completion: nil)
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
        cell.getImages = { [weak self] image in
            self?.comment?.getImages.append(image!)
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let click = clickItemBlock {
            click(self, indexPath.row, (comment?.getImages)!)
        }
    }
    
    
    
    
    
    
    
}











