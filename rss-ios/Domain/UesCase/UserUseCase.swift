//
//  UserUseCase.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 02/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserUseCase: NSObject {
    let disposeBag = DisposeBag()
    
    let userNetwork = GatewayBuilder.getUserNetwork()
    let userDatabase = GatewayBuilder.getUserDatabase()

    func socialLogin(socialObject: SocialLogin, success: @escaping ((SocialLoginResult) -> Void), failure: @escaping ((Error) -> Void)) {
        socialObject.socialLogin { (loginResult, error) in
            if let error = error {
                failure(error)
            } else if let loginResult = loginResult {
                success(loginResult)
            }
        }
    }
    
    func `init`(deviceToken: String?) -> Observable<LoginEntity?> {
        let loginEntity = self.userDatabase.loginUser()
        var accessToken: String?
        if (loginEntity?.anonymous ?? false) == false {
            accessToken = loginEntity?.token
        }
        
        return Observable<LoginEntity?>.create({ [weak self] observer -> Disposable in
            guard let `self` = self else { return Disposables.create() }
            let observable = self.userNetwork
                .init(deviceToken: deviceToken, accessToken: accessToken)
                .subscribe(onNext: { [weak self] (loginEntity) in
                    if let existLoginEntity = self?.userDatabase.loginUser() {
                        existLoginEntity.token = loginEntity?.token
                        self?.userDatabase.updateLoginUser(loginEntity: existLoginEntity)
                    } else if let loginEntity = loginEntity {
                        self?.userDatabase.updateLoginUser(loginEntity: loginEntity)
                    }
                    BaseNetwork.token = loginEntity?.token ?? ""
                    observer.onNext(loginEntity)
                },
                           onError: { (error) in
                            observer.onError(error)
                })
            return observable
        })
    }
    
    func login(socialUserId: String?,
               socialAccessToken: String?,
               socialType: String?,
               name: String?,
               profileUrl: String?) -> Observable<Void> {
        return Observable<Void>.create({ [weak self] observer -> Disposable in
            guard let `self` = self else { return Disposables.create() }
            let observable = self.userNetwork
                .login(socialUserId: socialUserId, socialAccessToken: socialAccessToken, socialType: socialType)
                .subscribe(onNext: { [weak self] (accessToken) in
                    if let accessToken = accessToken {
                        BaseNetwork.token = accessToken
                        if let loginEntity = self?.userDatabase.loginUser() {
                            loginEntity.token = accessToken
                            loginEntity.name = name
                            loginEntity.profileUrl = profileUrl
                            loginEntity.socialUserId = socialUserId
                            loginEntity.socialAccessToken = socialAccessToken
                            loginEntity.socialType = socialType
                            loginEntity.anonymous = false
                            self?.userDatabase.updateLoginUser(loginEntity: loginEntity)
                        }
                    }
                    observer.onNext(())
                    },
                           onError: { (error) in
                            observer.onError(error)
                })
            return observable
        })
    }
    
    func loginUserInfo() -> LoginEntity? {
        return userDatabase.loginUser()
    }
    
    func isLogin() -> Bool {
        if let loginEntity = userDatabase.loginUser() {
            return !(loginEntity.anonymous ?? true)
        }
        return false
    }
    
    func logout() -> Observable<Bool> {
        return Observable<Bool>.create({ [weak self] observer -> Disposable in
            guard let `self` = self else { return Disposables.create() }
            let observable = self.userNetwork.logout().subscribe(onNext: { [weak self] (logoutSuccess) in
                let loginEntity = self?.userDatabase.loginUser()
                
                self?.userDatabase.logout()
                
                let anonymousLoginEntity = LoginEntity()
                anonymousLoginEntity.apiVersion = loginEntity?.apiVersion
                anonymousLoginEntity.token = loginEntity?.token
                anonymousLoginEntity.anonymous = true
                self?.userDatabase.updateLoginUser(loginEntity: anonymousLoginEntity)
                
                observer.onNext(true)
            })
            return observable
        })
    }
}
