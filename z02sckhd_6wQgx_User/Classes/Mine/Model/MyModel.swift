//
//  MyModel.swift
//  TianMaUser
//
//  Created by YH_O on 2018/8/26.
//  Copyright © 2018 YH. All rights reserved.
//

import Foundation
import ObjectMapper
import YHTool

class NotEvaluateInfo: BaseModel {
    
    var data: NotEvaluateData?
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class NotEvaluateData: Mappable {
    
    var result = [NotEvaluateGoods]()
    var totalpage = 1
    var page = 1
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        result <- map["result"]
        totalpage <- map["totalpage"]
    }
}

class NotEvaluateGoods: Mappable {
    
    var rec_id = ""
    var order_id = "1"
    var goods_name = ""
    var goods_id = ""
    var goods_sn = ""
    var product_id = ""
    var goods_numbers = ""
    var number = ""
    var market_price = ""
    var goods_price = ""
    var goods_attr = ""
    var send_number = ""
    
    var parent_id = ""
    var goods_attr_id = ""
    var evaluation_status = ""
    var evaluation_time = ""
    var Score = ""
    var comment = ""
    var userid = ""
    var images = ""
    var status = ""
    var add_time = ""
    var total = ""
    var goods_image = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        rec_id <- map["rec_id"]
        order_id <- map["order_id"]
        goods_name <- map["goods_name"]
        goods_id <- map["goods_id"]
        goods_sn <- map["add_time"]
        product_id <- map["product_id"]
        goods_numbers <- map["goods_numbers"]
        number <- map["number"]
        market_price <- map["market_price"]
        goods_price <- map["goods_price"]
        goods_attr <- map["goods_attr"]
        send_number <- map["send_number"]
        
        parent_id <- map["parent_id"]
        goods_attr_id <- map["goods_attr_id"]
        evaluation_status <- map["evaluation_status"]
        evaluation_time <- map["evaluation_time"]
        Score <- map["Score"]
        comment <- map["comment"]
        userid <- map["userid"]
        images <- map["images"]
        status <- map["status"]
        add_time <- map["add_time"]
        total <- map["total"]
        goods_image <- map["goods_image"]
    }
}

class CollectInfo: BaseModel {
    
    var data: CollectData?
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class CollectData: Mappable {
    
    var result = [Collect]()
    var totalpage = 1
    var page = 1
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        result <- map["result"]
        totalpage <- map["totalpage"]
    }
}

class Collect: Mappable {
    
    var rec_id = ""
    var type = "1"
    var user_id = ""
    var goods_id = ""
    var add_time = ""
    var is_attention = "0"
    var default_image = ""
    var goods_name = ""
    var shopname = ""
    var banner = ""
    var price = "0"
    var spec = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        rec_id <- map["rec_id"]
        type <- map["type"]
        user_id <- map["user_id"]
        goods_id <- map["goods_id"]
        add_time <- map["add_time"]
        is_attention <- map["is_attention"]
        default_image <- map["default_image"]
        goods_name <- map["goods_name"]
        shopname <- map["shopname"]
        banner <- map["banner"]
        price <- map["price"]
        spec <- map["spec"]
    }
}

class MyOrderInfo: BaseModel {
    
    var data: MyOrderData?
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class MyOrderData: Mappable {
    
    var result = [MyOrderResult]()
    var totalpage = 1
    var page = 1
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        result <- map["result"]
        totalpage <- map["totalpage"]
    }
}

class MyOrderResult: Mappable {
    
    var mid = ""
    var extension_id = ""
    var give_integral = ""
    var consignee = ""
    var address = ""
    var address_name = ""
    var _orders = [MyOrder]()
    var pay_time = "0"
    var pay_way = ""
    var extension_code = ""
    var user_id = ""
    var integral = ""
    var order_amount = ""
    var tel = ""
    var is_pay = ""
    var add_time = "0"
    var order_sn = ""
    
    var total = "-1"
    var cellHeight: CGFloat = 0
    var detialCellHeight: CGFloat = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        mid <- map["mid"]
        extension_id <- map["extension_id"]
        give_integral <- map["give_integral"]
        consignee <- map["consignee"]
        address <- map["address"]
        address_name <- map["address_name"]
        _orders <- map["_orders"]
        pay_time <- map["pay_time"]
        pay_way <- map["pay_way"]
        extension_code <- map["extension_code"]
        user_id <- map["user_id"]
        integral <- map["integral"]
        order_amount <- map["order_amount"]
        tel <- map["tel"]
        is_pay <- map["is_pay"]
        add_time <- map["add_time"]
        order_sn <- map["order_sn"]
    }
}

class MyOrder: Mappable {
    
    var shipping_id = ""
    var order_id = ""
    var referer = ""
    var pay_note = ""
    var bonus = ""
    var reson = ""
    var pid = ""
    var order_status = ""
    var best_time = "0"
    var money_paid = ""
    var sign_building = ""
    var pack_name = "STO"
    var shipping_name = "申通"
    var invoice_no = "10000000"
    var order_amount = ""
    var tel = ""
    var consignee = ""
    var integral_money = ""
    var _goods = [MyOrderGoods]()
    
    var parent_id = ""
    var user_id = ""
    var zipcode = ""
    var shipping_time = ""
    var email = ""
    var address = ""
    var goods_amount = ""
    var mobile = ""
    var pay_name = ""
    var comment_status = ""
    var confirm_time = "0"
    var evaluation_status = ""
    var evaluation_time = "0"
    var myorder_id = ""
    var shopname = ""
    var pay_fee = ""
    var add_time = "0"
    var deliver_time = "0"
    var order_sn = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        shipping_id <- map["shipping_id"]
        order_id <- map["order_id"]
        referer <- map["referer"]
        pay_note <- map["pay_note"]
        bonus <- map["bonus"]
        reson <- map["reson"]
        pid <- map["pid"]
        order_status <- map["order_status"]
        best_time <- map["best_time"]
        money_paid <- map["money_paid"]
        sign_building <- map["sign_building"]
        shipping_name <- map["shipping_name"]
        pack_name <- map["pack_name"]
        invoice_no <- map["invoice_no"]
        order_amount <- map["order_amount"]
        tel <- map["tel"]
        consignee <- map["consignee"]
        integral_money <- map["integral_money"]
        _goods <- map["_goods"]
        
        parent_id <- map["parent_id"]
        user_id <- map["user_id"]
        zipcode <- map["zipcode"]
        shipping_time <- map["shipping_time"]
        email <- map["email"]
        address <- map["address"]
        goods_amount <- map["goods_amount"]
        mobile <- map["mobile"]
        pay_name <- map["pay_name"]
        comment_status <- map["comment_status"]
        evaluation_status <- map["evaluation_status"]
        evaluation_time <- map["evaluation_time"]
        confirm_time <- map["confirm_time"]
        myorder_id <- map["myorder_id"]
        shopname <- map["shopname"]
        pay_fee <- map["pay_fee"]
        add_time <- map["add_time"]
        deliver_time <- map["deliver_time"]
        order_sn <- map["order_sn"]
    }
}

class MyOrderGoods: Mappable {
    
    var income = ""
    var goods_price = ""
    var evaluation_status = ""
    var is_real = ""
    var goods_numbers = ""
    var goods_attr = ""
    var type = ""
    var rid = ""
    var userid = ""
    var point = ""
    var sid = ""
    var number = ""
    var extension_code = ""
    var total = ""
    var product_id = ""
    var goods_status = ""
    
    var goods_name = ""
    var images = ""
    var evaluation_time = ""
    var goods_id = ""
    var goods_sn = ""
    var rec_id = ""
    var goods_attr_id = ""
    var is_show = ""
    var Score = ""
    var goods_image = ""
    var is_gift = ""
    var parent_id = ""
    var market_price = ""
    var comment = ""
    var order_id = ""
    var add_time = ""
    var send_number = ""
    var status = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        income <- map["income"]
        goods_price <- map["goods_price"]
        evaluation_status <- map["evaluation_status"]
        is_real <- map["is_real"]
        goods_numbers <- map["goods_numbers"]
        goods_attr <- map["goods_attr"]
        type <- map["type"]
        rid <- map["rid"]
        userid <- map["userid"]
        point <- map["point"]
        sid <- map["sid"]
        number <- map["number"]
        extension_code <- map["extension_code"]
        total <- map["total"]
        product_id <- map["product_id"]
        goods_status <- map["goods_status"]
        
        goods_name <- map["goods_name"]
        images <- map["images"]
        evaluation_time <- map["evaluation_time"]
        goods_id <- map["goods_id"]
        goods_sn <- map["goods_sn"]
        rec_id <- map["rec_id"]
        goods_attr_id <- map["goods_attr_id"]
        is_show <- map["is_show"]
        Score <- map["Score"]
        goods_image <- map["goods_image"]
        is_gift <- map["is_gift"]
        parent_id <- map["parent_id"]
        market_price <- map["market_price"]
        comment <- map["comment"]
        order_id <- map["order_id"]
        add_time <- map["add_time"]
        send_number <- map["send_number"]
        status <- map["status"]
    }
}









