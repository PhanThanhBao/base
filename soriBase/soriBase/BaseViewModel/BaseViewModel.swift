//
//  BaseViewModel.swift
//  soriBase
//
//  Created by soriBao on 09/07/2023.
//

import Foundation
import RxSwift
import ObjectMapper

class BaseViewModel {
    //MARK: - Properties
    let disposeBag = DisposeBag()
    private(set) var messageErrorSubject = PublishSubject<String>()
    private(set) var loadingSubject = PublishSubject<Bool>()
    init() {}
    deinit {
        debugPrint("deinit \(self.self)")
    }

     func request<T: Mappable>(_ urlRequest: APIRouter, isLoading: Bool = true) -> Observable<T> {
        defer {
            if isLoading {
                loadingSubject.onNext(false)
            }
        }
        loadingSubject.onNext(isLoading)
        return Observable.create { observer -> Disposable  in
            APIClient.shared.request(urlRequest)
                .subscribe (onNext: { responseModel in
                observer.onNext(responseModel)
            }, onCompleted: {
                observer.on(.completed)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}
