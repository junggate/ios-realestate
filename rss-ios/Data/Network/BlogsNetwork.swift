//
//  BlogsNetwork.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 10/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import HandyJSON
import RxAlamofire
import RxSwift
import RxCocoa

class BlogsNetwork: BaseNetwork, BlogsNetworkGateway {
    func blogs(page: Int = 0) -> Observable<(page: PageEntity?, entities: [BlogEntity]?)> {
        return Observable<(page: PageEntity?, entities: [BlogEntity]?)>.create({ [weak self] (observer) -> Disposable in
            let param = ApiBlogListRequst()
            param.page = page
            param.size = 30
            _ = self?.request(api: ApiBlogList(), param: param).subscribe(onNext: { (headers, responseData) in
                let response = ApiBlogListResponse.deserialize(from: responseData as? [String: Any])
                observer.onNext((response?.toPage(), response?.toBlogEntities()))
            }, onError: { (error) in
                observer.onError(error)
            }, onCompleted: {
                observer.onCompleted()
            }, onDisposed: {
                print("onDisposed")
            })
            return Disposables.create()
        })
    }
}
