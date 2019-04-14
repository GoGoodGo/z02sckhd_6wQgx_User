//
//  EvaluateController.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/7.
//  Copyright © 2018 YH. All rights reserved.
//

import UIKit
import YHTool
import TMSDK

class EvaluateController: TMViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var evaluate: MyOrderGoods?
    var evaluateBtn: UIButton?
    var selectedRow = 0
    var images = [UIImage]()
    var selectionImage: MultipleImage?
    var score = "5.0"
    var comment = ""
    var imagesID = ""
    var flag = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "立即评价"
        selectionImage = MultipleImage.init(ctrl: self)
        selectionImage?.addPicCompletionBlock = { [weak self] images in
            self?.images = images
            self?.tableView.reloadData()
        }
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.item(title: "发表评论", titleColor: HexString("#3363ff"), target: self, action: #selector(publishEvaluate))
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        tableView.register(UINib.init(nibName: CellName(EvaluateGoodsCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(EvaluateGoodsCell.self))
        tableView.register(UINib.init(nibName: CellName(StarRatingCell.self), bundle: getBundle()), forCellReuseIdentifier: CellName(StarRatingCell.self))
        
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 20, right: 0)
    }
    /** 评价 */
    func load() {
        getRequest(baseUrl: Evaluate_URL, params: ["token" : TMHttpUserInstance.sharedManager().member_code ?? TestToken, "rec_id" : "\((evaluate?.rec_id)!)", "comment" : comment, "Score" : score, "images" : imagesID], success: { [weak self] (obj: BaseModel) in
            self?.hideHUD()
            if "success" == obj.status {
                self?.showAutoHideHUD(message: obj.msg!, completed: {
                    self?.evaluateBtn?.isEnabled = false
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
    /** 上传图片 */
    func uploadFile() {
        showHUD()
        flag = 0
        imagesID = ""
        if images.count > 0 {
            uploadImage(image: images[flag])
        } else {
            load()
        }
    }
    
    func uploadImage(image: UIImage) {
        NetworkingManager.uploadMultipartData(url: UploadFile_URL, multipart: { (formadata) in
            let imgData = image.jpegData(compressionQuality: 1.0)
            let imgPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last?.appending("/\(Date.currentDateStr()).jpeg")
            formadata.append(imgData!, withName: "file", fileName: imgPath!, mimeType: "image/jpeg")
        }, success: { [weak self] (result) in
            if result["status"].string! == "success" {
                self?.flag += 1
                self?.imagesID += result["data"]["id"].string! + ((self?.flag)! < (self?.images.count)! ? "," : "")
                if (self?.flag)! < (self?.images.count)! {
                    self?.uploadImage(image: (self?.images[(self?.flag)!])!)
                } else {
                    self?.load()
                    return
                }
            } else {
                self?.showAutoHideHUD(message: result["msg"].string!)
            }
        }) { (error) in
            self.hideHUD()
            self.inspectError()
        }
    }
    
    // MARK: - Callbacks
    private func callbacks(cell: StarRatingCell) {
        cell.touchRating = { [weak self] (rating, cell) in
            self?.score = "\(rating)"
        }
    }
    
    private func callbacks(cell: EvaluateGoodsCell) {
        cell.addImage = { [weak self] cell in
            self?.selectedRow = (self?.tableView.indexPath(for: cell)?.row)!
            self?.alertViewCtrlSelectePic(cancelHandler: nil, takePicHandler: { (action) in
                self?.selectionImage?.getImgFromCamera()
            }, photoLibraryHandler: { (action) in
                self?.selectionImage?.getImgFromPhotoLibrary()
            })
        }
        cell.delImage = { [weak self] (cell, index) in
            self?.selectedRow = (self?.tableView.indexPath(for: cell)?.row)!
            self?.alertViewCtrl(title: "提示", message: "确认删除此照片？", sureHandler: { (action) in
                
            }, cancelHandler: nil)
        }
        cell.commentBlock = { [weak self] text in
            self?.comment = text
        }
    }
    
    /** 发表评论 */
    @objc func publishEvaluate() {
        uploadFile()
    }
}

extension EvaluateController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName(EvaluateGoodsCell.self)) as! EvaluateGoodsCell
            callbacks(cell: cell)
            cell.images = images
            cell.goods = evaluate
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName(StarRatingCell.self)) as! StarRatingCell
            cell.index = indexPath.row
            callbacks(cell: cell)
            
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    
    
    
    
    
}











