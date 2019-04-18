//
//  UserNetwork.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 22/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import HandyJSON
import RxAlamofire
import RxSwift
import RxCocoa

class UserNetwork: BaseNetwork, UserNetworkGateway {
    func `init`(deviceToken: String?, accessToken: String?) -> Observable<LoginEntity?> {
        return Observable<LoginEntity?>.create({ [weak self] (observer) -> Disposable in
            let param = ApiInitRequst()
            param.deviceToken = deviceToken
            param.accessToken = accessToken
            
            let observer = self?.request(api: ApiInit(),
                                         param: param)
                .subscribe(onNext: { (headers, responseData) in
                    let response = ApiInitResponse.deserialize(from: responseData as? [String: Any])
                    observer.onNext(response?.toLoginEntities())
                }, onError: { (error) in
                    observer.onError(error)
                }, onCompleted: {
                    observer.onCompleted()
                }, onDisposed: {
                    
                })
            return observer!
        })
    }
    
    func login(socialUserId: String?,
               socialAccessToken: String?,
               socialType: String?) -> Observable<String?> {
        return Observable<String?>.create({ [weak self] (observer) -> Disposable in
            let param = ApiLoginRequst()
            param.socialUserId = socialUserId
            param.socialAccessToken = socialAccessToken
            param.socialType = socialType
            
            let observer = self?.request(api: ApiLogin(),
                                         param: param)
                .subscribe(onNext: { (headers, responseData) in
                    let response = ApiLoginResponse.deserialize(from: responseData as? [String: Any])
                    observer.onNext(response?.accessToken)
                }, onError: { (error) in
                    observer.onError(error)
                }, onCompleted: {
                    observer.onCompleted()
                }, onDisposed: {
                    
                })
            return observer!
        })
    }
    
    func logout() -> Observable<String?> {
        return Observable<String?>.create({ [weak self] (observer) -> Disposable in
            let param = ApiLogoutRequst()
            let observer = self?.request(api: ApiLogout(),
                                         param: param)
                .subscribe(onNext: { (headers, responseData) in
                    let response = ApiLogoutResponse.deserialize(from: responseData as? [String: Any])
                    observer.onNext(response?.logoutSuccess)
                }, onError: { (error) in
                    observer.onError(error)
                }, onCompleted: {
                    observer.onCompleted()
                }, onDisposed: {
                })
            return observer!
        })
    }
}
