//
//  GoodsModel.swift
//  TianMaUser
//
//  Created by YH_O on 2018/8/13.
//  Copyright © 2018 YH. All rights reserved.
//

import Foundation
import ObjectMapper
import YHTool

class ShareUrl: BaseModel {
    
    var data = ""
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class CommentInfo: BaseModel {
    
    var data: CommentData?
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class CommentData: Mappable {
    
    var result = [Comment]()
    var totalpage = 1
    var page = 1
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        result <- map["result"]
        totalpage <- map["totalpage"]
    }
}

class Comment: Mappable {
    
    var images = [CommentImage]()
    var getImages = [UIImage]()
    var Score = 0
    var user_id = 0
    var head_pic = "" // 暂不显示
    var goods_id = 0
    var comment = ""
    var member_name = ""
    var add_time = ""
    var reply_time = ""
    var reply_status = 0
    var reply_comment = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        images <- map["images"]
        Score <- map["Score"]
        user_id <- map["user_id"]
        head_pic <- map["head_pic"]
        goods_id <- map["goods_id"]
        comment <- map["comment"]
        member_name <- map["member_name"]
        add_time <- map["add_time"]
        reply_time <- map["reply_time"]
        reply_status <- map["reply_status"]
        reply_comment <- map["reply_comment"]
    }
}

class CommentImage: Mappable {
    
    var id = ""
    var path = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        path <- map["path"]
    }
}

class ShopInfo: BaseModel {
    
    var data: ShopData?
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class ShopData: Mappable {
    
    var seller: Seller?
    var category = [Category]()
    var isbest = [Goods]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        seller <- map["seller"]
        category <- map["category"]
        isbest <- map["isbest"]
    }
}

class Seller: Mappable {
    
    var id = 0
    var shopname = ""
    var banner = ""
    var logo = ""
    var is_collect = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        shopname <- map["shopname"]
        banner <- map["banner"]
        logo <- map["logo"]
        is_collect <- map["is_collect"]
    }
}

class AuctionBid: BaseModel {
    
    var data: AuctionData?
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class AuctionData: Mappable {
    
    var act_id = ""
    var is_top = 0
    var tel = ""
    var bid_user = 0
    var bid_time = 0
    var bid_price = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        is_top <- map["is_top"]
        act_id <- map["act_id"]
        tel <- map["tel"]
        bid_user <- map["bid_user"]
        bid_time <- map["bid_time"]
        bid_price <- map["bid_price"]
    }
}

class OrderInfo: BaseModel {
    
    var data: Order?
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class Order: Mappable {
    
    var order_id = ""
    var order_sn = ""
    var orderAmount = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        order_id <- map["order_id"]
        order_sn <- map["order_sn"]
    }
}

class PayInfo: BaseModel {
    
    var data = ""
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class WxPayInfo: BaseModel {
    
    var data: Pay?
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class Pay: Mappable {
    
    var appid = ""
    var noncestr = ""
    var package = ""
    var partnerid = ""
    var prepayid = ""
    var timestamp: UInt32 = 0
    var sign = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        appid <- map["appid"]
        noncestr <- map["noncestr"]
        package <- map["package"]
        partnerid <- map["partnerid"]
        prepayid <- map["prepayid"]
        timestamp <- map["timestamp"]
        sign <- map["sign"]
    }
}

class DataInfo: BaseModel {
    
    var data: GoodsInfo?
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class GoodsInfo: Mappable {
    
    var totalpage = 1
    var page = 1
    var result = [Goods]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        totalpage <- map["totalpage"]
        result <- map["result"]
    }
}

class SalesDetialInfo: BaseModel {
    
    var data: SalesDetialData?
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class SalesDetialData: Mappable {
    
    var store: SalesStore?
    var goods: GoodsDetial?
    var is_top = 0
    var onum = 0
    var auctionlog = [AuctionLog]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        store <- map["store"]
        goods <- map["goods"]
        is_top <- map["is_top"]
        onum <- map["onum"]
        auctionlog <- map["auctionlog"]
    }
}

class AuctionLog: Mappable {
    
    var id = 0
    var act_id = 0
    var tel = ""
    var bid_user = ""
    var bid_price = ""
    var bid_time = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        act_id <- map["act_id"]
        tel <- map["tel"]
        bid_user <- map["bid_user"]
        bid_price <- map["bid_price"]
        bid_time <- map["bid_time"]
    }
}

class SalesStore: Mappable {
    
    var act_id = 0
    var act_type = 0
    var goods_id = 0
    var goods_name = ""
    var start_time = ""
    var end_time = ""
    var is_finished = 0
    
    var is_end = false // 是否结束
    
    var new_price = "" // 当前价格
    var ext_info = ""
    var total = 0
    var number = 10000
    var price = "0.00"
    var spec_id = 0
    var spec_name = ""
    var num = 1000
    var pid = 0
    var markups = "0.00"
    var maxprice = "0.00"
    var sid = 0
    var type = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        act_id <- map["act_id"]
        act_type <- map["act_type"]
        goods_id <- map["goods_id"]
        goods_name <- map["goods_name"]
        start_time <- map["start_time"]
        end_time <- map["end_time"]
        is_finished <- map["is_finished"]
        
        new_price <- map["new_price"]
        
        ext_info <- map["ext_info"]
        total <- map["total"]
        number <- map["number"]
        price <- map["price"]
        spec_id <- map["spec_id"]
        spec_name <- map["spec_name"]
        num <- map["num"]
        pid <- map["pid"]
        markups <- map["markups"]
        maxprice <- map["maxprice"]
        sid <- map["sid"]
        type <- map["type"]
    }
}

class DetialInfo: BaseModel {
    
    var data: GoodsDetial?
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class GoodsDetial: Mappable {
    
    var give_integral = 0 // 获取积分 -1 不送
    var default_spec = 0 // 规格
    var seo_keys = ""
    var description = ""
    var click_count = 0
    var sales = 0 // 销量
    var sid = 0 // 商户 id
    var is_shipping = false
    var is_best = false
    var is_promote = false
    var is_hot = false
    var is_del = false
    var is_new = false
    var is_collect = 0
    var price = "0.00"
    var discount_price = ""
    var integral = 0
    var last_update = 0
    var from = "0"
    var brand = ""
    var collects = 0
    var views = 0
    var goods_weight = "0.00"
    var cost_price = "0.00"
    var promote_start_date = 0
    var rank_integral = ""
    var goods_name = ""
    var spec_name_1 = "颜色"
    var spec_name_2 = "尺码"
    var promote_end_date = ""
    var seo_desc = ""
    var comments = 0
    var spec_qty = 0
    var goods_id = 0
    var goods_sn = ""
    var promote_price = "0.00"
    var cate_id = 0 // 商品分类
    var sort = 0
    var carts = 0
    var goods_number = 0
    var market_price = "0.00"
    var default_image = "" // 默认封面
    var orders = 0
    var goods_type = 0
    var is_check = false
    var add_time = 0
    var status = false //是否下架
    var cate_name = ""
    var phone = ""
    var pay_fee: Float = 0.00
    var _images = [GoodsImage]()
    var _specs = [GoodsSpec]()
    var _specs_all = [GoodsSpec]()
    var defaultspec: GoodsSpec?
    var attr = [GoodsAttr]()
    var _statistics: SalesStatistics?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        
        give_integral <- map["give_integral"]
        default_spec <- map["default_spec"]
        seo_keys <- map["seo_keys"]
        is_shipping <- map["is_shipping"]
        description <- map["description"]
        click_count <- map["click_count"]
        is_best <- map["is_best"]
        sales <- map["sales"]
        sid <- map["sid"]
        is_promote <- map["is_promote"]
        is_hot <- map["is_hot"]
        is_del <- map["is_del"]
        is_collect <- map["is_collect"]
        price <- map["price"]
        integral <- map["integral"]
        last_update <- map["last_update"]
        from <- map["from"]
        brand <- map["brand"]
        collects <- map["collects"]
        views <- map["views"]
        goods_weight <- map["goods_weight"]
        cost_price <- map["cost_price"]
        promote_start_date <- map["promote_start_date"]
        rank_integral <- map["rank_integral"]
        goods_name <- map["goods_name"]
        spec_name_1 <- map["spec_name_1"]
        spec_name_2 <- map["spec_name_2"]
        promote_end_date <- map["promote_end_date"]
        seo_desc <- map["seo_desc"]
        comments <- map["comments"]
        is_new <- map["is_new"]
        spec_qty <- map["spec_qty"]
        goods_id <- map["goods_id"]
        goods_sn <- map["goods_sn"]
        promote_price <- map["promote_price"]
        cate_id <- map["cate_id"]
        sort <- map["sort"]
        carts <- map["carts"]
        goods_number <- map["goods_number"]
        market_price <- map["market_price"]
        default_image <- map["default_image"]
        orders <- map["orders"]
        goods_type <- map["goods_type"]
        is_check <- map["is_check"]
        add_time <- map["add_time"]
        cate_name <- map["cate_name"]
        phone <- map["phone"]
        pay_fee <- map["pay_fee"]
        status <- map["status"]
        _images <- map["_images"]
        _specs <- map["_specs"]
        _specs_all <- map["_specs_all"]
        defaultspec <- map["defaultspec"]
        attr <- map["attr"]
        _statistics <- map["_statistics"]
    }
}

class GoodsImage: Mappable {
    
    var id = 0
    var gid = 0
    var fid = 0
    var url = ""
    var thumb = ""
    var sort = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        gid <- map["gid"]
        fid <- map["fid"]
        url <- map["url"]
        thumb <- map["thumb"]
        sort <- map["sort"]
    }
}

class GoodsSpec: Mappable {
    
    var spec_id = 0
    var goods_id = 0
    var spec_1 = ""
    var spec_2 = ""
    var color_rgb = ""
    var price = "0.00"
    var stock = 0
    var sku = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        spec_id <- map["spec_id"]
        goods_id <- map["goods_id"]
        spec_1 <- map["spec_1"]
        spec_2 <- map["spec_2"]
        color_rgb <- map["color_rgb"]
        price <- map["price"]
        stock <- map["stock"]
        sku <- map["sku"]
    }
}

class GoodsAttr: Mappable {
    
    var aid = 0
    var value = ""
    var attr_name = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        aid <- map["aid"]
        value <- map["value"]
        attr_name <- map["attr_name"]
    }
}


class Goods: Mappable {
    
    var give_integral = -1 // 获取积分 -1 不送
    var default_spec = 0 // 规格
    var seo_keys = ""
    var is_shipping = false
    var description = ""
    var click_count = 0
    var is_best = false
    var sales = 0 // 销量
    var pay_number = 0 // 付款人数
    var sid = 0 // 商户 id
    var is_promote = false
    var is_hot = false
    var integral = 0
    var last_update = 0
    var from = "0"
    var brand = ""
    var collects = 0
    var views = 0
    var goods_weight = "0.00"
    var price = "0.00"
    var cost_price = "0.00"
    var market_price = "0.00"
    var promote_price = "0.00"
    var promote_start_date = 0
    var promote_end_date = 0
    var rank_integral = -1
    var goods_name = ""
    var spec_name_1 = "颜色"
    var spec_name_2 = "尺码"
    var seo_desc = ""
    var comments = 0
    var is_new = false
    var spec_qty = 0
    var goods_id = 0
    var goods_sn = ""
    var cate_id = 0 // 商品分类
    var sort = 0
    var carts = 0
    var goods_number = 1
    var default_image = "" // 默认封面
    var orders = 0
    var goods_type = 0
    var is_check = false
    var add_time = 0
    var status = false //是否下架
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        
        give_integral <- map["give_integral"]
        default_spec <- map["default_spec"]
        seo_keys <- map["seo_keys"]
        is_shipping <- map["is_shipping"]
        description <- map["description"]
        click_count <- map["click_count"]
        is_best <- map["is_best"]
        sales <- map["sales"]
        pay_number <- map["pay_number"]
        sid <- map["sid"]
        is_promote <- map["is_promote"]
        is_hot <- map["is_hot"]
        price <- map["price"]
        integral <- map["integral"]
        last_update <- map["last_update"]
        from <- map["from"]
        brand <- map["brand"]
        collects <- map["collects"]
        views <- map["views"]
        goods_weight <- map["goods_weight"]
        cost_price <- map["cost_price"]
        promote_start_date <- map["promote_start_date"]
        rank_integral <- map["rank_integral"]
        goods_name <- map["goods_name"]
        spec_name_1 <- map["spec_name_1"]
        spec_name_2 <- map["spec_name_2"]
        promote_end_date <- map["promote_end_date"]
        seo_desc <- map["seo_desc"]
        comments <- map["comments"]
        is_new <- map["is_new"]
        spec_qty <- map["spec_qty"]
        goods_id <- map["goods_id"]
        goods_sn <- map["goods_sn"]
        promote_price <- map["promote_price"]
        cate_id <- map["cate_id"]
        sort <- map["sort"]
        carts <- map["carts"]
        goods_number <- map["goods_number"]
        market_price <- map["market_price"]
        default_image <- map["default_image"]
        orders <- map["orders"]
        goods_type <- map["goods_type"]
        is_check <- map["is_check"]
        add_time <- map["add_time"]
        status <- map["status"]
        
    }
    

}

















