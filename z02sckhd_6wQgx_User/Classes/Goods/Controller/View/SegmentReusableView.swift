//
//  SegmentReusableView.swift
//  TianMaUser
//
//  Created by YH_O on 2018/7/30.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool

class SegmentReusableView: UICollectionReusableView {
    
    let titles = ["新品上线", "热销宝贝"]
    var clickItem: ((_ index: Int) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - PrivateMethod
    private func setupUI() {
        
        addSubview(segmentView)
        segmentCallbacks()
    }
    
    // MARK: - Callbacks
    private func segmentCallbacks() {
        segmentView.clickItemBlock = { [weak self] (index) in
            if let click = self?.clickItem {
                click(index)
            }
        }
    }
    
    // MARK: - Getter
    private lazy var segmentView: YHSegmentView = {
        
        let view = YHSegmentView.init(frame: CGRect.init(x: 0, y: 10, width: WIDTH, height: 50), titles: self.titles)
        view.normalColor = HexString("#444")
        view.selectedColor = HexString("#ff5b63")
        view.indicatorColor = HexString("#ff5b63")
        return view
    }()
    
    
    
    
    
    
    
    
}
