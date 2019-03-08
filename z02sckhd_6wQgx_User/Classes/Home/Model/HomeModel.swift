//
//  HomeModel.swift
//  TianMaUser
//
//  Created by YH_O on 2018/8/15.
//  Copyright © 2018 YH. All rights reserved.
//

import Foundation
import ObjectMapper
import YHTool

class ShopListInfo: BaseModel {
    
    var data: ShopListData?
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
    @objc public func arouseAppAction(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(openArouseApp), name:
            NSNotification.Name("kTMAppDelegateHandleOpenURLNotification") , object: nil)
        
        
    }
    
    @objc func openArouseApp(noti:Notification){
        
        let kWindow = UIApplication.shared.keyWindow
        let vc = kWindow?.currentViewController()
        let url:URL = noti.object as! URL
        let str = url.absoluteString
        let arr = str.components(separatedBy: "goods_id=")
        let goodsDetialCtrl = GoodsDetialController.init(nibName: "GoodsDetialController", bundle: getBundle())
        goodsDetialCtrl.goodsID = arr[1]
        vc?.navigationController?.pushViewController(goodsDetialCtrl, animated: true)
        
    }
    
}



class ShopListData: Mappable {
    
    var totalpage = 1
    var page = 1
    var result = [HomeShop]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        totalpage <- map["totalpage"]
        result <- map["result"]
    }
}

class HomeInfo: BaseModel {
    
    var data: HomeData?
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class HomeData: Mappable {
    
    var banner = [HomeBanner]()
    var category = [CategoryInfo]()
    var spike = [SalesResult]()
    var groupbuy = [SalesResult]()
    var auction = [SalesResult]()
    var isbest = [Goods]()
    var bestshop = [HomeShop]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        banner <- map["banner"]
        category <- map["category"]
        spike <- map["spike"]
        groupbuy <- map["groupbuy"]
        auction <- map["auction"]
        isbest <- map["isbest"]
        bestshop <- map["bestshop"]
    }
}

class HomeBanner: Mappable {
    
    var id = 0
    var name = ""
    var type = ""
    var position = 0
    var url = ""
    var content = ""
    var start_time = 0
    var close_time = 0
    var status = 0
    var litpic = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        type <- map["type"]
        position <- map["position"]
        url <- map["url"]
        content <- map["content"]
        start_time <- map["start_time"]
        close_time <- map["close_time"]
        status <- map["status"]
        litpic <- map["litpic"]
    }
}

class Category: Mappable {
    
    var id = 0
    var pid = 0
    var image = ""
    var name = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        pid <- map["pid"]
        image <- map["image"]
        name <- map["name"]
    }
}

class HomeShop: Mappable {
    
    var id = 0
    var shopname = ""
    var banner = ""
    var logo = ""
    var sales = 0
    var total = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        shopname <- map["shopname"]
        banner <- map["banner"]
        logo <- map["logo"]
        sales <- map["sales"]
        total <- map["total"]
    }
}

class SalesInfo: BaseModel {
    
    var data: SalesData?
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class SalesData: Mappable {
    
    var result = [SalesResult]()
    var totalpage = 1
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        result <- map["result"]
        totalpage <- map["totalpage"]
    }
}

class SalesResult: Mappable {
    
    var act_id = 0
    var act_type = 0
    var goods_id = 0
    var goods_name = ""
    var start_time = ""
    var end_time = ""
    var is_finished = 0
    var ext_info = ""
    var total = 0
    var number = 0
    var num = 0
    var price = ""
    var new_price = ""
    var spec_id = 0
    
    var spec_name = ""
    var pid = 0
    var markups = ""
    var maxprice = ""
    var sid = 0
    var type = 0
    var default_image = ""
    var goods: SalesGoods?
    var surplus = 0
    var sales = 0
    var onum = 0
    
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
        ext_info <- map["ext_info"]
        total <- map["total"]
        number <- map["number"]
        num <- map["num"]
        price <- map["price"]
        new_price <- map["new_price"]
        spec_id <- map["spec_id"]
        
        spec_name <- map["spec_name"]
        pid <- map["pid"]
        markups <- map["markups"]
        maxprice <- map["maxprice"]
        sid <- map["sid"]
        type <- map["type"]
        default_image <- map["default_image"]
        goods <- map["goods"]
        surplus <- map["surplus"]
        sales <- map["sales"]
        onum <- map["onum"]
    }
}

class SalesGoods: Mappable {
    
    var goods_id = ""
    var goods_sn = ""
    var goods_number = ""
    var goods_name = ""
    var cate_id = ""
    var brand = ""
    var spec_qty = ""
    var spec_name_1 = ""
    var spec_name_2 = ""
    var goods_weight = ""
    var status = ""
    var add_time = ""
    
    var goods_type = ""
    var last_update = ""
    var default_spec = ""
    var default_image = ""
    var is_best = ""
    var is_new = ""
    var is_hot = ""
    var is_promote = ""
    var market_price = ""
    
    var price = ""
    var cost_price = ""
    var promote_price = ""
    var promote_start_date = ""
    var promote_end_date = ""
    var click_count = ""
    var is_shipping = ""
    var sort = ""
    var give_integral = ""
    
    var rank_integral = ""
    var integral = ""
    var is_check = ""
    var seo_keys = ""
    var seo_desc = ""
    var from = ""
    var sid = ""
    var is_del = ""
    
    var views = ""
    var collects = ""
    var carts = ""
    var orders = ""
    var sales = ""
    var comments = ""
    
    var _specs_all = [SalesSpecs]()
    var _images = [SalesImage]()
    var _statistics: SalesStatistics?
    var cate_name = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        goods_id <- map["goods_id"]
        goods_sn <- map["goods_sn"]
        goods_number <- map["goods_number"]
        goods_name <- map["goods_name"]
        cate_id <- map["cate_id"]
        brand <- map["brand"]
        spec_qty <- map["spec_qty"]
        spec_name_1 <- map["spec_name_1"]
        spec_name_2 <- map["spec_name_2"]
        goods_weight <- map["goods_weight"]
        status <- map["status"]
        add_time <- map["add_time"]
        
        goods_type <- map["goods_type"]
        last_update <- map["last_update"]
        default_spec <- map["default_spec"]
        default_image <- map["default_image"]
        is_best <- map["is_best"]
        is_new <- map["is_new"]
        is_hot <- map["is_hot"]
        is_promote <- map["is_promote"]
        market_price <- map["market_price"]
        
        price <- map["price"]
        cost_price <- map["cost_price"]
        promote_price <- map["promote_price"]
        promote_start_date <- map["promote_start_date"]
        promote_end_date <- map["promote_end_date"]
        click_count <- map["click_count"]
        is_shipping <- map["is_shipping"]
        sort <- map["sort"]
        give_integral <- map["give_integral"]
        
        rank_integral <- map["rank_integral"]
        integral <- map["integral"]
        is_check <- map["is_check"]
        seo_keys <- map["seo_keys"]
        seo_desc <- map["seo_desc"]
        from <- map["from"]
        sid <- map["sid"]
        is_del <- map["is_del"]
        
        views <- map["views"]
        collects <- map["collects"]
        carts <- map["carts"]
        orders <- map["orders"]
        sales <- map["sales"]
        comments <- map["comments"]
        
        _specs_all <- map["_specs_all"]
        _images <- map["_images"]
        _statistics <- map["_statistics"]
        cate_name <- map["cate_name"]
    }
}

class SalesSpecs: Mappable {
    
    var spec_id = ""
    var goods_id = ""
    var spec_1 = ""
    var spec_2 = ""
    var color_rgb = ""
    var price = ""
    var stock = ""
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

class SalesImage: Mappable {
    
    var id = ""
    var gid = ""
    var url = ""
    var thumb = ""
    var sort = ""
    var fid = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        gid <- map["gid"]
        url <- map["url"]
        thumb <- map["thumb"]
        sort <- map["sort"]
        fid <- map["fid"]
    }
}

class SalesStatistics: Mappable {
    
    var goods_id = 0
    var views = 0
    var collects = 0
    var carts = 0
    var orders = 0
    var sales = 0
    var comments = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        goods_id <- map["goods_id"]
        views <- map["views"]
        collects <- map["collects"]
        carts <- map["carts"]
        orders <- map["orders"]
        sales <- map["sales"]
        comments <- map["comments"]
    }
}

class GoodsCategory: BaseModel {
    
    var data = [CategoryInfo]()
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class CategoryInfo: Mappable {
    
    var image = ""
    var nav = 0
    var keywords = ""
    var filter_attr = ""
    var grade = 0
    var name = ""
    var pid = 0
    var id = 0
    var sort = ""
    var desc = ""
    var status = false
    var sid = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        image <- map["image"]
        nav <- map["nav"]
        keywords <- map["keywords"]
        filter_attr <- map["filter_attr"]
        grade <- map["grade"]
        name <- map["name"]
        pid <- map["pid"]
        id <- map["id"]
        sort <- map["sort"]
        desc <- map["desc"]
        status <- map["status"]
        sid <- map["sid"]
    }
}















