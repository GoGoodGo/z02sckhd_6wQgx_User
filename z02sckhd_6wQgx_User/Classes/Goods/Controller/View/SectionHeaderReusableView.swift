//
//  SectionHeaderReusableView.swift
//  TianMaUser
//
//  Created by YH_O on 2018/7/30.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool

let bannerH: CGFloat = 130

class SectionHeaderReusableView: UICollectionReusableView {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var bannerContent: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        bannerContent.addSubview(carouselView)
    }
    
    var imageUrl: String? {
        didSet {
            var images = [String]()
            images.append(imageUrl ?? "")
            carouselView.imgURLArr = images
        }
    }
    
    // MARK: - Getter
    lazy var carouselView: YHScrollView = {
        
        let view = YHScrollView.init(frame: CGRect.init(x: 0, y: 0, width: WIDTH, height: bannerH), imageName: Banners())!
        view.currentIndicatorColor = UIColor.black
        view.otherIndicatorColor = UIColor.white
        let width: CGFloat = CGFloat((Banners()?.count)! * 20)
        let height: CGFloat = 30
        view.indicatorFrame = CGRect.init(x: WIDTH - width, y: bannerH - height, width: width, height: height)
        return view
    }();
    
}



