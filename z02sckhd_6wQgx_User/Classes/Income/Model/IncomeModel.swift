//
//  IncomeModel.swift
//  TianMaUser
//
//  Created by Healson on 2018/8/31.
//  Copyright © 2018 YH. All rights reserved.
//

import Foundation
import ObjectMapper
import YHTool

class IncomeInfo: BaseModel {
    
    var data: IncomeData?
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class IncomeData: Mappable {
    
    var money = ""
    var result = [Income]()
    var totalpage = 1
    var page = 1
    var wait: CGFloat = 0.00
    var ok: CGFloat = 0.00
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        money <- map["money"]
        result <- map["result"]
        totalpage <- map["totalpage"]
        page <- map["page"]
        wait <- map["wait"]
        ok <- map["ok"]
    }
}

class Income: Mappable {
    
    var id = ""
    var order_id = ""
    var type = "11"
    var uid = ""
    var price = "0.00"
    var status = ""
    
    var bank = ""
    var content = ""
    var balance = "0.00"
    var mouth = ""
    var total = "0.00"
    var add_time = ""
    var sign = ""
    var edit_time = ""
    var way = "1"
    var is_show = ""
    var form = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        order_id <- map["order_id"]
        type <- map["type"]
        uid <- map["uid"]
        price <- map["price"]
        status <- map["status"]
        
        bank <- map["bank"]
        content <- map["content"]
        balance <- map["balance"]
        mouth <- map["mouth"]
        total <- map["total"]
        add_time <- map["add_time"]
        sign <- map["sign"]
        edit_time <- map["edit_time"]
        way <- map["way"]
        is_show <- map["is_show"]
        form <- map["form"]
    }
}

class AccountInfo: BaseModel {
    
    var data: AccountData?
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class AccountData: Mappable {
    
    var result = [Account]()
    var totalpage = 1
    var page = 1
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        result <- map["result"]
        totalpage <- map["totalpage"]
    }
}

class Account: Mappable {
    
    var id = ""
    var user_id = ""
    var type = "1"
    var number = ""
    var is_default = "0"
    var add_time = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        user_id <- map["user_id"]
        type <- map["type"]
        number <- map["number"]
        is_default <- map["is_default"]
        add_time <- map["add_time"]
    }
}

















