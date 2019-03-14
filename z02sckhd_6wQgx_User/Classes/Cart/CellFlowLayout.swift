//
//  CellFlowLayout.swift
//  AFNetworking
//
//  Created by 虞淞晴 on 2019/3/14.
//

import UIKit

class CellFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        //尺寸
        itemSize = (collectionView?.bounds.size)!
        //间距
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        //滚动方向
        scrollDirection = .horizontal
    }
}
