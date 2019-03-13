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
    var pay: ((_ specs: String, _ num: Int) -> Void)?
    var selectedItems = [Int : IndexPath]()
    var specID = ""
    var limitNum = ""
    var goodsNum = 1
    var selectedIndexPath: IndexPath?
    
    var isPush = 0
    
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
    public func isShowOption(isShow: Bool, specificGap: CGFloat ,isPush: Int) {
        self.isPush = isPush
        collectionView.isHidden = specificGap == 0
        stock.isHidden = specificGap == 0
        specific.isHidden = specificGap != 0
        
        layer.shadowOffset = CGSize.init(width: 0, height: isShow ? -1 : 0)
        UIView.animate(withDuration: 0.3) {
            self.y = isShow ? HEIGHT / 2 - specificGap - NavigationBarH : HEIGHT
            if isPush == 1{
                 self.y = isShow ? HEIGHT / 2 - specificGap : HEIGHT
            }
            else{
                self.y = isShow ? HEIGHT / 2 - specificGap - NavigationBarH : HEIGHT
            }
        }
        if !isShow {
            specID = ""
            goodsNum = 1
            number.text = "\(goodsNum)"
            selectedItems.removeAll()
        }
    }
    
    @IBAction func action_updateNum(_ sender: UIButton) {
        
        let tag = sender.tag - btnTag
        goodsNum = Int(number.text!)!
        switch tag {
        case 0:
            goodsNum -= 1
            if goodsNum <= 1 {
                goodsNum = 1
            }
        default:
            goodsNum += 1
            if !limitNum.isEmpty {
                if goodsNum > Int(limitNum)! {
                    goodsNum = Int(limitNum)!
                }
            }
        }
        number.text = "\(goodsNum)"
    }
    
    @IBAction func action_pay(_ sender: UIButton) {
        if let click = pay {
            click(specID, goodsNum)
        }
    }
    
    @IBAction func action_close() {
        isShowOption(isShow: false, specificGap: 0, isPush: self.isPush)
    }
    
    // MARK: - Setter
    var goodsDetial: GoodsDetial? {
        didSet {
            let url = URL.init(string: (goodsDetial?.default_image)!)
            imgView.kf.setImage(with: url)
            name.text = goodsDetial?.goods_name
            price.text = (goodsDetial?.discount_price.isEmpty ?? false) ? "¥\(goodsDetial?.price ?? "0.00")" : "¥\(goodsDetial?.discount_price ?? "0.00")"
            specific.text = (goodsDetial?.defaultspec?.spec_1 ?? "") + (goodsDetial?.defaultspec?.spec_2 ?? "")
            
            collectionView.reloadData()
            if goodsDetial?._specs.count ?? 0 > 0 {
                selectedIndexPath = IndexPath.init(row: 0, section: 0)
                collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .top)
                specID = "\((goodsDetial?._specs.first?.spec_id)!)"
            }
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
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if selectedIndexPath == indexPath {
            return false
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: selectedIndexPath!, animated: true)
        selectedIndexPath = indexPath
        
        if (goodsDetial?.discount_price.isEmpty ?? false) {
            price.text = goodsDetial?._specs[indexPath.row].price
        }
        
        selectedItems[indexPath.section] = indexPath
        specID = "\((goodsDetial?._specs[indexPath.row].spec_id)!)"
        let goodsStock = goodsDetial?._specs[indexPath.row].stock ?? 0
        
        if goodsStock < Int(number.text ?? "0")! {
            number.text = "\(goodsStock)"
            goodsNum = goodsStock
        }
        stock.text = "库存\(goodsStock)件"
        limitNum = "\(goodsStock)"
    }
    
    
    
}









