//
//  BaseResponse.swift
//  soriBase
//
//  Created by soriBao on 09/07/2023.
//

import Foundation
import ObjectMapper

class BaseResponse<T: Mappable>: Mappable {
    var status: Bool?
    var code: Int?
    var message: String?
    var data: T?
    var listData: [T]?
    var messageArr: [String]?

    required init?(map: Map) { }
    
    func mapping(map: Map) {
        status      <- map["Status"]
        code        <- map["result"]
        message     <- map["Message"]
        data        <- map["Data"]
        listData    <- map["listData"]
        messageArr  <- map["error"]
    }
}

extension BaseResponse {
    var isSuccess: Bool {
        return code == 200
    }
}
