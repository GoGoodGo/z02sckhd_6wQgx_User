//
//  SearchController.swift
//  TianMaUser
//
//  Created by YH_O on 2018/7/26.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool

class SearchController: UIViewController {
    
    @IBOutlet weak var searchResult: UIButton!
    @IBOutlet weak var segmentContent: UIView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let gap: CGFloat = 15.0
    let titles = ["商品", "店铺"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        searchTextF.removeFromSuperview()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - PrivateMethod
    private func setupUI() {
        
        segmentContent.addSubview(segmentView)
        segmentCallbacks()
        
        navigationController?.navigationBar.addSubview(searchTextF)
        navigationItem.rightBarButtonItem = UIBarButtonItem.item(title: "搜索", target: self, action: #selector(action_search))
        
        let width = (WIDTH - gap * 3) / 2
        let height = width + gap + 60
        layout.itemSize = CGSize.init(width: width, height: height)
        layout.minimumLineSpacing = gap
        
        collectionView.register(UINib.init(nibName: CellName(RecommendGoodsCell.self), bundle: getBundle()), forCellWithReuseIdentifier: CellName(RecommendGoodsCell.self))
        
        collectionView.contentInset = UIEdgeInsets.init(top: gap, left: gap, bottom: gap, right: gap)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Callbacks
    @objc private func action_search() {
        navigationController?.navigationBar.endEditing(true)
        
    }
    
    private func segmentCallbacks() {
        segmentView.clickItemBlock = { [weak self] (index) in
            self?.navigationController?.navigationBar.endEditing(true)
            print("index = \(index)")
        }
    }
    
    // MARK: - Getter
    private lazy var segmentView: YHSegmentView = {
        
        let view = YHSegmentView.init(frame: CGRect.init(x: 0, y: 0, width: WIDTH, height: 50), titles: self.titles)
        view.normalColor = HexString("#444")
        view.selectedColor = HexString("#ff5b63")
        view.indicatorColor = HexString("#ff5b63")
        return view
    }()
    
    private lazy var searchTextF: YHTextField = {
        
        let height: CGFloat = 30
        let gap: CGFloat = 50
        let textField = YHTextField.init(frame: CGRect.init(x: gap - 10, y: (NavigationBarH - height - 20) / 2, width: WIDTH - gap * 2, height: height))
        textField.delegate = self
        textField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        textField.returnKeyType = .search
        textField.clearButtonMode = .whileEditing
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeholder = "请输入宝贝名称"
        textField.layer.cornerRadius = height / 2
        textField.fontSize = 12
        
        return textField
    }()

}

extension SearchController: UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName(RecommendGoodsCell.self), for: indexPath) as! RecommendGoodsCell
        
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationController?.navigationBar.endEditing(true)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        navigationController?.navigationBar.endEditing(true)
        
        return true
    }
}













