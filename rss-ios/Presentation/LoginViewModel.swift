//
//  LoginViewModel.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 02/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewModel: CommonViewModel {
    let userUseCase = UserUseCase()

    // Input
    var inputKakaoRegister: Driver<Void>? { didSet { kakaoRegister() } }
    var inputFacebookRegister: Driver<Void>? { didSet { facebookRegister() } }
    var inputNaverRegister: Driver<Void>? { didSet { naverRegister() } }

    // Output
    let outputLoginComplete = PublishSubject<Void>()
    
    override init() {
        super.init()
        setupInput()
    }
    
    func setupInput( ) {
    }
    
    /// 회원가입 (카카오)
    func kakaoRegister() {
        inputKakaoRegister?.drive(onNext: { [weak self] in
            self?.socialLogin(loginObject: KakaoLogin())
        }).disposed(by: disposeBag)
    }
    
    /// 회원가입 (페이스북)
    func facebookRegister() {
        inputFacebookRegister?
            .throttle(2.0)
            .drive(onNext: { [weak self] in
            self?.socialLogin(loginObject: FacebookLogin())
        }).disposed(by: disposeBag)
    }

    /// 회원가입 (네이버)
    func naverRegister() {
        inputNaverRegister?
            .drive(onNext: { [weak self] in
            self?.socialLogin(loginObject: NaverLogin())
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Private
    private func socialLogin(loginObject: SocialLogin) {
        var loginObject: SocialLogin? = loginObject
        userUseCase.socialLogin(socialObject: loginObject!,
                                success: { [weak self] (loginResult) in
                                    print("Social Token \(loginResult.accessToken!)")
                                    self?.serviceLogin(loginObject: loginResult)
                                    loginObject = nil
            },
                                failure: { [weak self] (error) in
                                    self?.outputToast.onNext(error.localizedDescription)
                                    loginObject = nil
        })
    }
    
    private func serviceLogin(loginObject: SocialLoginResult) {
        userUseCase.login(socialUserId: loginObject.id,
                          socialAccessToken: loginObject.accessToken,
                          socialType: loginObject.socialType,
                          name: loginObject.name,
                          profileUrl: loginObject.profileImage)
            .subscribe(onNext: { [weak self] in
                print("login complete")
                self?.outputToast.onNext("로그인에 성공했습니다.")
                self?.outputLoginComplete.onNext(())
            }).disposed(by: disposeBag)
    }
}
