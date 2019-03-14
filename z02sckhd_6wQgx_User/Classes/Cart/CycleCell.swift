//
//  CycleCell.swift
//  AFNetworking
//
//  Created by 虞淞晴 on 2019/3/14.
//

import UIKit

class CycleCell: UICollectionViewCell {
    
    var mode : contentMode? {
        didSet{
            switch mode ?? .scaleAspectFill {
            case .scaleAspectFill:
                imageView.contentMode = .scaleAspectFill
            case .scaleAspectFit:
                imageView.contentMode = .scaleAspectFit
            }
        }
    }
    
    //FIXME: 本地和网络下载走的不同路径
    var imageURLString : String? {
        didSet{
            if (imageURLString?.hasPrefix("http"))! {
                //网络图片:使用SDWebImage下载即可
                imageView.kf.setImage(with: URL.init(string: imageURLString!))
            } else {
                //本地图片
                imageView.image = UIImage(named: imageURLString!)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 懒加载
    lazy var imageView : UIImageView = {
        let imageView = UIImageView(frame: bounds)
        imageView.clipsToBounds = true
        return imageView
    }()
}

//MARK: 设置UI
extension CycleCell {
    fileprivate func setUpUI() {
        contentView.addSubview(imageView)
    }
}

