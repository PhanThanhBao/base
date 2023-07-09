//
//  BaseModel.swift
//  soriBase
//
//  Created by soriBao on 09/07/2023.
//

import Foundation
import ObjectMapper

class BaseModel: Mappable {
    required init?(map: Map) { }
    
    func mapping(map: Map) { }
}
