//
//  BindingController.swift
//  z02sckhd_6wQgx_User
//
//  Created by Healson on 2018/10/17.
//

import UIKit
import TMSDK
import YHTool

class BindingController: UIViewController {
    
    @IBOutlet weak var bindingLabel: UILabel!
    @IBOutlet weak var binding: UITextField!
    @IBOutlet weak var bindingBtn: UIButton!
    @IBOutlet weak var bindingTop: NSLayoutConstraint!
    
    @IBOutlet weak var QRcode: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "分销绑定"
        bindingTop.constant = HeightPercent(120)
        binding.layer.borderColor = HexString("#e2e2e2").cgColor
        
        loadUserDetial()
        
    }
    
    /** 获取用户信息 */
    func loadUserDetial() {
        showHUD()
        getRequest(baseUrl: UserDetial_URL, params: ["token" : TMHttpUser.token() ?? TestToken], success: { [weak self] (obj: UserInfo) in
            self?.hideHUD()
            if "success" == obj.status {
                if obj.data?.pid != 0 {
                    self?.bindingLabel.text = "您已绑定\(obj.data?.pidname ?? "")"
                    self?.binding.text = obj.data?.pidcode
                    self?.binding.isEnabled = false
                    self?.bindingBtn.isEnabled = false
                    
               
                    //生成图片并且显示
                    self?.QRcode.image = self?.setupQRCodeImage((obj.data?.pidcode)!, image: nil)
                    
                    
                    
                }
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
    }
    
    func bindingUser(code: String) {
        showHUD()
        getRequest(baseUrl: Binding_URL, params: ["token" : TMHttpUser.token() ?? TestToken, "code" : code], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.showAutoHideHUD(message: "绑定成功！", completed: {
                    self?.navigationController?.popViewController(animated: true)
                })
            } else {
                self?.inspectLogin(model: obj)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
    }
    
    @IBAction func action_binding(_ sender: UIButton) {
        if let code = binding.text {
            bindingUser(code: code)
        } else {
            showAutoHideHUD(message: "请输入邀请码！")
        }
    }
    
    //MARK: -传进去字符串,生成二维码图片
    func setupQRCodeImage(_ text: String, image: UIImage?) -> UIImage {
        //创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        //将url加入二维码
        filter?.setValue(text.data(using: String.Encoding.utf8), forKey: "inputMessage")
        //取出生成的二维码（不清晰）
        if let outputImage = filter?.outputImage {
            //生成清晰度更好的二维码
            let qrCodeImage = setupHighDefinitionUIImage(outputImage, size: 300)
//            //如果有一个头像的话，将头像加入二维码中心
//            if var image = image {
//                //给头像加一个白色圆边（如果没有这个需求直接忽略）
//                image = circleImageWithImage(image, borderWidth: 50, borderColor: UIColor.white)
//                //合成图片
//                let newImage = syntheticImage(qrCodeImage, iconImage: image, width: 100, height: 100)
//
//                return newImage
//            }
            
            return qrCodeImage
        }
        
        return UIImage()
    }
    
    //image: 二维码 iconImage:头像图片 width: 头像的宽 height: 头像的宽
    func syntheticImage(_ image: UIImage, iconImage:UIImage, width: CGFloat, height: CGFloat) -> UIImage{
        //开启图片上下文
        UIGraphicsBeginImageContext(image.size)
        //绘制背景图片
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let x = (image.size.width - width) * 0.5
        let y = (image.size.height - height) * 0.5
        iconImage.draw(in: CGRect(x: x, y: y, width: width, height: height))
        //取出绘制好的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        //返回合成好的图片
        if let newImage = newImage {
            return newImage
        }
        return UIImage()
    }
    
    //MARK: - 生成高清的UIImage
    func setupHighDefinitionUIImage(_ image: CIImage, size: CGFloat) -> UIImage {
        let integral: CGRect = image.extent.integral
        let proportion: CGFloat = min(size/integral.width, size/integral.height)
        
        let width = integral.width * proportion
        let height = integral.height * proportion
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: integral)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: proportion, y: proportion);
        bitmapRef.draw(bitmapImage, in: integral);
        let image: CGImage = bitmapRef.makeImage()!
        return UIImage(cgImage: image)
    }
    
    //生成边框
    func circleImageWithImage(_ sourceImage: UIImage, borderWidth: CGFloat, borderColor: UIColor) -> UIImage {
        let imageWidth = sourceImage.size.width + 2 * borderWidth
        let imageHeight = sourceImage.size.height + 2 * borderWidth
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageWidth, height: imageHeight), false, 0.0)
        UIGraphicsGetCurrentContext()
        
        let radius = (sourceImage.size.width < sourceImage.size.height ? sourceImage.size.width:sourceImage.size.height) * 0.5
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x: imageWidth * 0.5, y: imageHeight * 0.5), radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        bezierPath.lineWidth = borderWidth
        borderColor.setStroke()
        bezierPath.stroke()
        bezierPath.addClip()
        sourceImage.draw(in: CGRect(x: borderWidth, y: borderWidth, width: sourceImage.size.width, height: sourceImage.size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    

}
