//
//  CItemCell.swift
//  AFNetworking
//
//  Created by 虞淞晴 on 2019/3/16.
//

import UIKit

class CItemCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    
    lazy var itemLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - PrivateMethod
    private func setupSubviews() {
        
        self.contentView.addSubview(itemLabel)

        itemLabel.snp.makeConstraints({ (make) in
            
            make.top.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(0)
            
        })
        
    }
    // MARK: - Setter
    public var background: UIColor = .white {
        didSet {
            backgroundColor = background
            itemLabel.backgroundColor = background
        }
    }
    
    public var normalColor: UIColor = .white {
        didSet {
            itemLabel.textColor = isSelected ? selectedColor : normalColor
        }
    }
    
    public var selectedColor: UIColor = .black {
        didSet {
            itemLabel.textColor = isSelected ? selectedColor : normalColor
        }
    }
    
    override var isSelected: Bool {
        didSet {
            itemLabel.textColor = isSelected ? selectedColor : normalColor
        }
    }
}
