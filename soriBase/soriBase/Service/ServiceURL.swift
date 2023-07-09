//
//  ServiceURL.swift
//  soriBase
//
//  Created by soriBao on 09/07/2023.
//

import Foundation
public class ServiceURL {
    //MARK: - Properties
    private init() {}
    
    public static let shared = ServiceURL()
    public var baseURL: String = ""
}
