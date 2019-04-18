//
//  BaseNetwork.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 10/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import HandyJSON
import Alamofire

class BaseNetwork: NSObject {
    let disposeBag = DisposeBag()
    static var token = ""
    
    func request(api: ApiBase, param: HandyJSON? = nil)  -> Observable<(HTTPURLResponse, Any)> {
        return Observable<(HTTPURLResponse, Any)>.create({ (observer) -> Disposable in
            let observable = RxAlamofire.requestJSON(api.method,
                                                     api.getUrl(),
                                                     parameters: param?.toJSON(),
                                                     headers: ["Authorization": "Bearer \(BaseNetwork.token)"])
                .debug()
                .subscribe(onNext: { (headers, responseData) in
                    if headers.statusCode != 200, let responseData = responseData as? [String: Any] {
                        let error = NSError(domain: "Response Error", code: headers.statusCode, userInfo: responseData)
                        Toast.show(title: responseData["message"] as? String)
                        observer.onError(error)
                    } else {
                        observer.onNext((headers, responseData))
                    }
                },
                           onError: { (error) in
                            observer.onError(error)
                },
                           onCompleted: {
                            observer.onCompleted()
                },
                           onDisposed: {
                })
            return observable
        })
    }
}
