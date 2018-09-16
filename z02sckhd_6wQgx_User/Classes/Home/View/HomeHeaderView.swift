//
//  HomeHeaderView.swift
//  TianMaUser
//
//  Created by Healson on 2018/7/25.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool

class HomeHeaderView: UICollectionReusableView {
    
    let bannerHeight: CGFloat = 200
    var clickItemBlock: ((_ index: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(carouselView)
        addSubview(collectionView)
        addSubview(separator)
        addSubview(imgView)
        addSubview(separatorLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    private func getItemWidth() -> CGFloat {
        let gap:CGFloat = WidthPercent(20.0)
        let width = (WIDTH - gap * 3) / 4
        return width
    }
    
    public func getItemHeight() -> CGFloat {
        
        let scale: CGFloat = 1.3
        return getItemWidth() * scale
    }
    
    // MARK: - Setter
    var categorys = [CategoryInfo]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var images = [String]() {
        didSet {
            carouselView.imgURLArr = images
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
    }();
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        
        layout.itemSize = CGSize.init(width: getItemWidth(), height: getItemHeight())
        layout.minimumLineSpacing = 0
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView.init(frame: CGRect.init(x: 0, y: self.carouselView.frame.maxY, width: WIDTH, height: getItemHeight() * 2), collectionViewLayout:self.layout)
        view.register(UINib.init(nibName: CellName(GoodsTypesCell.self), bundle: nil), forCellWithReuseIdentifier: CellName(GoodsTypesCell.self))
        view.isScrollEnabled = false
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private lazy var separator: UIImageView = {
       let view = UIImageView.init(frame: CGRect.init(x: 0, y: collectionView.frame.maxY, width: WIDTH, height: 10))
        view.backgroundColor = SeparatorColor
        
        return view
    }()
    
    private lazy var imgView: UIImageView = {
       let view = UIImageView.init(frame: CGRect.init(x: 0, y: separator.frame.maxY, width: 180, height: 50))
        view.centerX = self.centerX
        view.image = UIImage.init(named: "ico_img_xspm.png")
        return view
    }()
    
    private lazy var separatorLine: UIImageView = {
        let view = UIImageView.init(frame: CGRect.init(x: 0, y: imgView.frame.maxY, width: WIDTH, height: 1))
        view.backgroundColor = SeparatorColor
        
        return view
    }()
}

extension HomeHeaderView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categorys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName(GoodsTypesCell.self), for: indexPath) as! GoodsTypesCell
        cell.index = indexPath.row
        cell.category = categorys[indexPath.row]
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let click = clickItemBlock {
            click(indexPath.row)
        }
        
    }
    
    
}




