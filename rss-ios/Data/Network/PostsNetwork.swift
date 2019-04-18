//
//  PostsNetwork.swift
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

class PostsNetwork: BaseNetwork, PostsNetworkGateway {
    func posts(isRecent: Bool, page: Int = 0) -> Observable<(page: PageEntity?, entities: [PostEntity?]?)> {
        return Observable<(page: PageEntity?, entities: [PostEntity?]?)>.create({ [weak self](observer) -> Disposable in
            let param = ApiPostListRequst()
            param.page = page
            param.size = 20
            param.order = "desc"
            param.isRecent = isRecent ? "true" : "false"
            _ = self?.request(api: ApiPostList(), param: param).subscribe(onNext: { (headers, responseData) in
                let response = ApiPostListResponse.deserialize(from: responseData as? [String: Any])
                observer.onNext((response?.toPage(), response?.toPostEntities()))
            }, onError: { (error) in
                observer.onError(error)
            }, onCompleted: {
//                observer.onCompleted()
            }, onDisposed: {
                print("onDisposed")
            })
            return Disposables.create()
        })
    }
}
