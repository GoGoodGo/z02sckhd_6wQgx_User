//
//  CartModel.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/24.
//  Copyright © 2018 YH. All rights reserved.
//

import Foundation
import ObjectMapper
import YHTool

class CartInfo: BaseModel {
    
    var data: Cart?
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class CartOrderInfo: BaseModel {
    
    var data: CartOrder?
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class CartOrder: Mappable {
    
    var total: CartTotal?
    var goods_list: CartStoreList?
    var consignee_default = [Address]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        total <- map["total"]
        goods_list <- map["goods_list"]
        consignee_default <- map["consignee_default"]
    }
}

class CartStoreList: Mappable {
    
    var amount = 0
    var quantity = 1
    var goods = [CartStore]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        amount <- map["amount"]
        quantity <- map["quantity"]
        goods <- map["goods"]
    }
}

class CartTotal: Mappable {
    
    var give_integral = 0
    var my_integral = "0"
    var my_money = "0"
    var surplus = 0
    var pay_fee = 0
    var goods_price: Float = 0.00
    var is_integral_pay = 0
    var integral = 0
    var market_price = 0
    var goods_price_formated = ""
    var integral_money = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        give_integral <- map["give_integral"]
        my_integral <- map["my_integral"]
        my_money <- map["my_money"]
        surplus <- map["surplus"]
        pay_fee <- map["pay_fee"]
        goods_price <- map["goods_price"]
        is_integral_pay <- map["is_integral_pay"]
        integral <- map["integral"]
        market_price <- map["market_price"]
        goods_price_formated <- map["goods_price_formated"]
        integral_money <- map["integral_money"]
    }
}

class Cart: Mappable {
    
    var amount: Float = 0.00
    var quantity = 1
    var goods = [CartStore]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        amount <- map["amount"]
        quantity <- map["quantity"]
        goods <- map["goods"]
    }
}

class CartStore: Mappable {
    
    var shopname = ""
    var sid = ""
    var result = [CartGoods]()
    var totalQuantity = "0"
    var notes = ""
    var isSelected = false
    var amount: Float = 0.0
    var usable = 0 // 可使用
    var give = 0 // 可获得
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        shopname <- map["shopname"]
        sid <- map["sid"]
        result <- map["result"]
    }
}

class CartGoods: Mappable {
    
    var goods_name = ""
    var give_integral = ""
    var quantity = "1"
    var is_shipping = "0"
    var session_id = ""
    var goods_id = ""
    var specification = ""
    var rec_id = ""
    var sid = ""
    var income = ""
    var goods_image = ""
    var rec_type = ""
    var user_id = ""
    var spec_id = ""
    var price = "0.00"
    var integral = ""
    var market_price = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        goods_name <- map["goods_name"]
        give_integral <- map["give_integral"]
        quantity <- map["quantity"]
        is_shipping <- map["is_shipping"]
        session_id <- map["session_id"]
        goods_id <- map["goods_id"]
        specification <- map["specification"]
        rec_id <- map["rec_id"]
        sid <- map["sid"]
        income <- map["income"]
        goods_image <- map["goods_image"]
        rec_type <- map["rec_type"]
        user_id <- map["user_id"]
        spec_id <- map["spec_id"]
        price <- map["price"]
        integral <- map["integral"]
        market_price <- map["market_price"]
    }
}










