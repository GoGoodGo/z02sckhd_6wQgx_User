//
//  AddressModel.swift
//  TianMaUser
//
//  Created by YH_O on 2018/8/21.
//  Copyright © 2018 YH. All rights reserved.
//

import Foundation
import ObjectMapper
import YHTool

class LogisticsInfo: BaseModel {
    
    var data: LogisticsData?
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class LogisticsData: Mappable {
    
    var LogisticCode = ""
    var ShipperCode = ""
    var State = ""
    var Traces = [Trace]()
    var EBusinessID = ""
    var Reason = ""
    var Success = false
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        LogisticCode <- map["LogisticCode"]
        ShipperCode <- map["ShipperCode"]
        State <- map["State"]
        Traces <- map["Traces"]
        EBusinessID <- map["EBusinessID"]
        Reason <- map["Reason"]
        Success <- map["Success"]
    }
}

class Trace: Mappable {
    
    var AcceptStation = ""
    var AcceptTime = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        AcceptStation <- map["AcceptStation"]
        AcceptTime <- map["AcceptTime"]
    }
}

class AddressInfo: BaseModel {
    
    var data = [Address]()
    
    override func mapping(map: Map) {
        
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class Address: Mappable {
    
    var address_id = ""
    var address_name = ""
    var user_id = ""
    var consignee = ""
    var email = ""
    var region_id = ""
    var address = ""
    var zipcode = ""
    var tel = ""
    var mobile = ""
    var sign_building = ""
    var point_lng = ""
    var point_lat = ""
    var is_default = "0"
    var best_time = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        address_id <- map["address_id"]
        address_name <- map["address_name"]
        user_id <- map["user_id"]
        consignee <- map["consignee"]
        email <- map["email"]
        region_id <- map["region_id"]
        address <- map["address"]
        zipcode <- map["zipcode"]
        tel <- map["tel"]
        mobile <- map["mobile"]
        sign_building <- map["sign_building"]
        point_lng <- map["point_lng"]
        point_lat <- map["point_lat"]
        is_default <- map["is_default"]
        best_time <- map["best_time"]
    }
}














