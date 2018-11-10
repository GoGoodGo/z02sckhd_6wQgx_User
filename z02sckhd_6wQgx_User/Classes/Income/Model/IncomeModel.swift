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

class UserInfo: BaseModel {
    
    var data: User?
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class User: Mappable {
    
    var user_id = ""
    var mid = ""
    var user_money = ""
    var frozen_money = ""
    var integral = ""
    var user_address = ""
    var add_time = ""
    var pid = ""
    var code = ""
    var tel = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        user_id <- map["user_id"]
        mid <- map["mid"]
        user_money <- map["user_money"]
        frozen_money <- map["frozen_money"]
        integral <- map["integral"]
        user_address <- map["user_address"]
        add_time <- map["add_time"]
        pid <- map["pid"]
        code <- map["code"]
        tel <- map["tel"]
    }
}

class MyMemberInfo: BaseModel {
    
    var data: MemberData?
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class MemberData: Mappable {
    
    var result = [Member]()
    var totalpage = 1
    var page = 1
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        result <- map["result"]
        totalpage <- map["totalpage"]
    }
}

class Member: Mappable {
    
    var user_id = ""
    var mobile = ""
    var head_pic = ""
    var member_name = ""
    var add_time = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        user_id <- map["user_id"]
        mobile <- map["mobile"]
        head_pic <- map["head_pic"]
        member_name <- map["member_name"]
        add_time <- map["add_time"]
    }
}

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
    var wait: Float = 0.00
    var ok: Float = 0.00
    
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
    
    var id = 0
    var order_id = ""
    var type = 0
    var uid = 0
    var price = "0.00"
    var status = 0
    
    var bank = ""
    var content = ""
    var balance = "0.00"
    var mouth = ""
    var total = "0.00"
    var add_time = ""
    var sign = ""
    var edit_time = ""
    var way = 0
    var is_show = false
    var form = 0
    
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
    
    var id = 0
    var user_id = 0
    var type = 0
    var number = ""
    var is_default = false
    var add_time = 0
    
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

















