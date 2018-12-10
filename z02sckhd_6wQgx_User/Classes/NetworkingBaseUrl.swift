//
//  NetworkingBaseUrl.swift
//  E_User
//
//  Created by YH_O on 2017/5/24.
//  Copyright © 2017年 OYH. All rights reserved.
//

import Foundation
import YHTool
import TMSDK

let IMG_URL = ""
//let TestToken = "2E214A98E2FEAF00DF358020F0A60021"

//let BASE_URL = TMEngineConfig.instance().domain!
let BASE_URL = "http://shop.dktoo.com"
let TestToken = ""

public let getBundle: () -> Bundle = {
    
    let bundle = Bundle.init(for: YHNavigaitonController.self)
    let url = bundle.url(forResource: ("z02sckhd_6wQgx_User"), withExtension: "bundle")
    return Bundle.init(url: url!)!
}

public let bundle: (AnyClass) -> Bundle = { any in
    
    let bundle = Bundle.init(for: any)
    let url = bundle.url(forResource: ("z02sckhd_6wQgx_User"), withExtension: "bundle")
    return Bundle.init(url: url!)!
}

public let getImage: (AnyClass, String) -> UIImage? = { any, name in
    
    let imageBundle = bundle(any)
    let scale = Int(UIScreen.main.scale)
    let path = imageBundle.path(forResource: name + "@\(scale)x", ofType: "png")
    
    return UIImage.init(contentsOfFile: path!)
}

/** 商品 */

// 商品分类
public let GoodsCategory_URL = BASE_URL + "/z02sckhd_6wqgx/apigoods/category"

// 商品列表
public let GoodsList_URL = BASE_URL + "/z02sckhd_6wqgx/apigoods/index"

// 商品详情
public let GoodsDetial_URL = BASE_URL + "/z02sckhd_6wqgx/apigoods/detail"

// 商品评论
public let GoodsComment_URL = BASE_URL + "/z02sckhd_6wqgx/apigoods/getcomment"

// 店铺详情
public let ShopDetial_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/shopdetail"

// 店铺列表
public let ShopList_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/shoplist"


/** 促销活动 */

// 拍卖列表
public let GoodsAuction_URL = BASE_URL + "/z02sckhd_6wqgx/apiauction/index"

// 竞拍详情
public let AuctionDetial_URL = BASE_URL + "/z02sckhd_6wqgx/apiauction/detail"

// 团购列表
public let GoodsGroup_URL = BASE_URL + "/z02sckhd_6wqgx/apigroup/index"

// 团购详情
public let GroupDetial_URL = BASE_URL + "/z02sckhd_6wqgx/apigroup/detail"

// 秒杀列表
public let GoodsTimelimit_URL = BASE_URL + "/z02sckhd_6wqgx/apispike/index"

// 秒杀详情
public let TimelimitDetial_URL = BASE_URL + "/z02sckhd_6wqgx/apispike/detail"

// 竞拍出价
public let AuctionBid_URL = BASE_URL + "/z02sckhd_6wqgx/apiauction/bidders"

// 竞拍购买
public let AuctionBuy_URL = BASE_URL + "/z02sckhd_6wqgx/apiauction/buy"

// 团购购买
public let GroupBuy_URL = BASE_URL + "/z02sckhd_6wqgx/apigroup/buy"

// 秒杀购买
public let TimelimitBuy_URL = BASE_URL + "/z02sckhd_6wqgx/apispike/buy"


/** 我的 */

// 用户信息
public let UserDetial_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/detail"

// 绑定上级
public let Binding_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/bind"

// 我的地址
public let Address_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/myaddress"

// 新增地址
public let AddAddress_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/add_address"

// 编辑地址
public let EditAddress_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/editress"

// 删除地址
public let DelAddress_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/deladdress"

// 是否默认
public let DefaultAddress_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/is_default"

// 收藏
public let AddCollect_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/addcollect"

// 取消收藏
public let CancelCollect_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/delcollect"

// 我的收藏
public let MyCollect_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/collection"

// 我的订单
public let MyOrder_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/myorder"

// 待评价
public let NotEvaluate_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/ordergoods"

// 评价
public let Evaluate_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/comment"

// 图片上传
public let UploadFile_URL = BASE_URL + "/z02sckhd_6wqgx/api/uploadfile"

// 取消订单
public let OrderCancel_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/cancel"

// 确认收货
public let OrderReceive_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/receive"

// 新增提现账户
public let AddAccount_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/addaccount"

// 我的账户
public let MyAccount_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/myaccount"

// 编辑账户
public let EditAccount_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/editaccount"

// 删除账户
public let DelAccount_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/delaccount"

// 设置默认账户
public let SetDefaultAccount_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/default_account"

// 首页
public let Home_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/index"

// 物流信息
public let OrderTraces_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/getOrderTracesByJson"

// 退换货
public let ReturnGoods_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/returngoods"


/** 购物车 */

// 加入购物车
public let AddCart_URL = BASE_URL + "/z02sckhd_6wqgx/apicart/add"

// 购物车
public let Cart_URL = BASE_URL + "/z02sckhd_6wqgx/apicart/index"

// 更新数量
public let CartQuantity_URL = BASE_URL + "/z02sckhd_6wqgx/apicart/update"

// 商品单选
public let CartCheck_URL = BASE_URL + "/z02sckhd_6wqgx/apicart/one_check"

// 商品全选
public let CartAllCheck_URL = BASE_URL + "/z02sckhd_6wqgx/apicart/all_check"

// 删除商品
public let CartDelete_URL = BASE_URL + "/z02sckhd_6wqgx/apicart/drop"

/** 订单 */

// 提交购物车
public let CartSubmit_URL = BASE_URL + "/z02sckhd_6wqgx/apiorder/index"

// 订单生成
public let OrderDone_URL = BASE_URL + "/z02sckhd_6wqgx/apiorder/done"

// 订单详情
public let OrderDetial_URL = BASE_URL + "/z02sckhd_6wqgx/apiorder/orders_detail"

// 立即购买
public let Buy_URL = BASE_URL + "/z02sckhd_6wqgx/apiorder/buy"

// 订单支付
public let OrderPay_URL = BASE_URL + "/z02sckhd_6wqgx/apipay/orderinfo"

/** 收益 */

// 我的钱包
public let Income_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/wallet"

// 申请提现
public let ApplyWithdraw_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/apptixian"

// 取消提现
public let CancelWithdraw_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/canceltixian"

// 我的会员
public let MyMember_URL = BASE_URL + "/z02sckhd_6wqgx/apiuser/myfriend"
























