//
//  APIClient.swift
//  soriBase
//
//  Created by soriBao on 09/07/2023.
//

import Foundation
import Foundation
import Alamofire
import RxSwift
//import SwiftyJSON
import RxAlamofire
import ObjectMapper

public class APIClient: NSObject {
    // MARK: - Properties
    public static let shared = APIClient()
    let disposeBag = DisposeBag()
    
    // MARK: - Functions
    public override init() { }
    
    func request<T: Mappable>(_ urlRequest: APIRouter) -> Observable<T> {
        return Observable.create({ observer -> Disposable in
            RxAlamofire.requestJSON(urlRequest)
                .debug()
                .subscribe(onNext: { (r, json) in
                    guard let object = Mapper<T>().map(JSONObject: json) else {
                        observer.on(.completed)
                        return
                    }
                    observer.onNext(object)
                }, onError: { (error) in
                    observer.onError(error)
                }, onCompleted: {
                    observer.on(.completed)
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
    
    func multipart<T: Mappable> (urlRequest: APIRouter,
                          data: @escaping (MultipartFormData) -> ()) -> Observable<T> {
        return Observable.create { observer in
            RxAlamofire.upload(multipartFormData: data, urlRequest: urlRequest).subscribe(onNext: { result in
                debugPrint(result)
                result.responseJSON { response in
                    debugPrint(response)
                    switch response.result {
                    case .success(let value):
                        guard let object = Mapper<T>().map(JSONObject: value) else {
                            observer.on(.completed)
                            return
                        }
                        observer.onNext(object)
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            }, onError: { (error) in
                observer.onError(error)
            }, onCompleted: {
                observer.on(.completed)
            })
            .disposed(by: self.disposeBag)
            return Disposables.create() { }
        }
    }
    
    public class RequestComponents: URLRequestConvertible {
        // MARK: - BaseURL
        var baseURL: String = ""
        
        // MARK: - VERSION
        var version: String = ""
        
        // MARK: - URL
        var urlString: String = ""
        
        // MARK: - HTTPMETHOD
        var httpMethod: HTTPMethod = .get
        
        // MARK: - HEADER
        var httpHeaders: [HTTPHeader] = []
        
        // MARK: - BODY PARAMS
        var httpBody: Data?
        
        // MARK: - URL PARAMS
        var urlParameters: [String: Any] = [:]
        
        public func asURLRequest() throws -> URLRequest {
            var paramString = ""
            if urlParameters.count > 0 {
                for (index,item) in urlParameters.enumerated() {
                    if index == 0 {
                        paramString.append("?\(item.key)=\(item.value)")
                    } else {
                        paramString.append("&\(item.key)=\(item.value)")
                    }
                }
            }
            
            let path = "\(baseURL)\(version)\(urlString)\(paramString)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            let url = URL(string: path)
            var urlRequest = URLRequest(url: url!)
            urlRequest.allHTTPHeaderFields = Dictionary(uniqueKeysWithValues: httpHeaders.map {($0.name, $0.value)})
            urlRequest.httpMethod = httpMethod.rawValue
            
            if httpMethod != .get {
                urlRequest.httpBody = httpBody
            }
            return urlRequest
        }
        
        // MARK: - Init
        public init(method: HTTPMethod,
                    baseURL: String,
                    version: String = "",
                    url: String,
                    params: [String : Any],
                    paramsArray: [[String : Any]],
                    headers: [HTTPHeader]) {
            // Generate HTTPMethod
            self.httpMethod = method
            
            // Generate Host URL
            self.baseURL = baseURL
            
            //Generate Version
            self.version = version
            
            // Generate API URL
            self.urlString = url
            
            // Generate Headers
            self.httpHeaders = headers
            
            // Generate HTTPBody
            if self.httpMethod == HTTPMethod.post {
                if paramsArray.count > 0 {
                    guard let body = try? JSONSerialization.data(withJSONObject: paramsArray, options: .prettyPrinted) else { return }
                    self.httpBody = body
                } else {
                    guard let body = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) else { return }
                    self.httpBody = body
                }
            } else {
                self.urlParameters = params
            }
        }
    }
}
