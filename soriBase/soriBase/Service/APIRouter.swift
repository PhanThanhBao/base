//
//  APIRouter.swift
//  soriBase
//
//  Created by soriBao on 09/07/2023.
//

import Foundation
import Foundation
import Alamofire

//**//
enum APIRouter: URLRequestConvertible {
    // =========== Begin define api ===========
    case masterData
    // =========== End define api ===========
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        return .post
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .masterData:
            return ""
        }
    }
    
    // MARK: - Headers
    private var headers: HTTPHeaders {
        var headers: HTTPHeaders = ["Accept": "application/json"]
        return headers
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        return nil
    }
    
    // MARK: - URL request
    func asURLRequest() throws -> URLRequest {
        let url = try ServiceURL.shared.baseURL.asURL()
        
        // setting path
        var urlRequest: URLRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // setting method
        urlRequest.httpMethod = method.rawValue
        
        // setting timeout
        urlRequest.timeoutInterval = TimeInterval(10*1000)
        
        // setting header
        headers.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.name)
        }
        
        // === access token
//        urlRequest.addValue(getAuthorizationHeader() ?? "", forHTTPHeaderField: "Authorization")
        
        //setting paramaters
        if let parameters = parameters {
            do {
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            } catch {
                print("Encoding fail")
            }
        }
        
        return urlRequest
    }
    
//    private func getAuthorizationHeader() -> String? {
//        return "Bearer \(Global.shared.token)"
//    }
}
