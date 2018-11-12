//
//  SpecificOptionView.swift
//  AFNetworking
//
//  Created by Healson on 2018/9/26.
//

import UIKit
import YHTool

class SpecificOptionView: UIView {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var stock: UILabel!
    @IBOutlet weak var specific: UILabel!
    @IBOutlet weak var buyBtn: UIButton!
    
    let btnTag = 434
    var updateNum: ((_ num: Int) -> Void)?
    var pay: ((_ specs: String) -> Void)?
    var selectedItems = [Int : IndexPath]()
    var specID = ""
    var limitNum = "10000"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        layout.itemSize = CGSize.init(width: 70, height: 25)
        
        collectionView.register(UINib.init(nibName: CellName(SpecificOptionReusableView.self), bundle: getBundle()), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: SpecificOptionReusableView.self))
        collectionView.register(UINib.init(nibName: CellName(GoodsParameterCell.self), bundle: getBundle()), forCellWithReuseIdentifier: CellName(GoodsParameterCell.self))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.6
    }
    
    // MARK: - XIB View
    public class func specificOption() -> Any? {
        
        return bundle(self).loadNibNamed(String(describing: self), owner: nil, options: nil)?.last
    }
    /** 是否显示 */
    public func isShowOption(isShow: Bool, specificGap: CGFloat) {
        
        collectionView.isHidden = specificGap == 0
        stock.isHidden = specificGap == 0
        specific.isHidden = specificGap != 0
        
        layer.shadowOffset = CGSize.init(width: 0, height: isShow ? -1 : 0)
        UIView.animate(withDuration: 0.3) {
            self.y = isShow ? HEIGHT / 2 - specificGap - NavigationBarH : HEIGHT
        }
        if !isShow {
            specID = ""
            selectedItems.removeAll()
        }
    }
    
    @IBAction func action_updateNum(_ sender: UIButton) {
        
        let tag = sender.tag - btnTag
        var num = Int(number.text!)!
        switch tag {
        case 0:
            num -= 1
            if num <= 1 {
                num = 1
            }
        default:
            num += 1
            if num > Int(limitNum)! {
                num = Int(limitNum)!
            }
        }
        if let click = updateNum {
            click(num)
        }
        number.text = "\(num)"
    }
    
    @IBAction func action_pay(_ sender: UIButton) {
        if let click = pay {
            click(specID)
        }
    }
    
    @IBAction func action_close() {
        isShowOption(isShow: false, specificGap: 0)
    }
    
    // MARK: - Setter
    var goodsDetial: GoodsDetial? {
        didSet {
            let url = URL.init(string: (goodsDetial?.default_image)!)
            imgView.kf.setImage(with: url)
            name.text = goodsDetial?.goods_name
            price.text = "¥\(goodsDetial?.price ?? "0.00")"
            specific.text = (goodsDetial?.defaultspec?.spec_1 ?? "") + (goodsDetial?.defaultspec?.spec_2 ?? "")
            
            collectionView.reloadData()
        }
    }
    
}

extension SpecificOptionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1 + ((goodsDetial?.spec_name_2.isEmpty ?? false) ? 0 : 1)
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodsDetial?._specs.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName(GoodsParameterCell.self), for: indexPath) as! GoodsParameterCell
        let spec = goodsDetial?._specs[indexPath.row]
//        cell.title.setTitle(indexPath.section == 0 ? spec?.spec_1 : spec?.spec_2, for: .normal)
        cell.title.setTitle((spec?.spec_1)! + (spec?.spec_2)!, for: .normal)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellName(SpecificOptionReusableView.self), for: indexPath) as! SpecificOptionReusableView
//        headerView.title.text = indexPath.row == 0 ? goodsDetial?.spec_name_1 : goodsDetial?.spec_name_2
        headerView.title.text = "规格"
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.init(width: WIDTH, height: 30)
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let itemIndex = selectedItems[indexPath.section] {
            collectionView.deselectItem(at: itemIndex, animated: true)
        }
        selectedItems[indexPath.section] = indexPath
        specID = "\((goodsDetial?._specs[indexPath.row].spec_id)!)"
        stock.text = "库存\((goodsDetial?._specs[indexPath.row].stock ?? 0)!)件"
    }
    
    
    
}









