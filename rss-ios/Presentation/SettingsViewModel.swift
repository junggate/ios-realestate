//
//  SettingsViewModel.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 06/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsViewModel: CommonViewModel {
    let userUseCase = UserUseCase()
    
    // Input
    let inputCheckLogin = PublishSubject<Void>()
    let inputLogout = PublishSubject<Void>()
    
    // Output
    let outputLogoutHidden = PublishSubject<Bool>()
    let outputLogoutCompleted = PublishSubject<Void>()
    
    override init() {
        super.init()
        setupInput()
    }
    
    func setupInput() {
        inputCheckLogin.subscribe(onNext: { [weak self] in
            let loginEntity = self?.userUseCase.loginUserInfo()
            let anonymous = loginEntity?.anonymous ?? true
            self?.outputLogoutHidden.onNext(anonymous)
        }).disposed(by: disposeBag)
        
        inputLogout.subscribe(onNext: { [weak self] in
            guard let disposeBag = self?.disposeBag else { return }
            self?.userUseCase.logout().subscribe(onNext: { [weak self] (success) in
                self?.outputLogoutCompleted.onNext(())
            }).disposed(by: disposeBag)
        }).disposed(by: disposeBag)
    }
}
