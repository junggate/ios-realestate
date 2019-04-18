//
//  MyViewModel.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 20/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyViewModel: NSObject {
    let disposeBag = DisposeBag()
    let userUseCase = UserUseCase()
    
    // Input
    let inputLoadUserInfo = PublishSubject<Void>()
    
    // Output
    let outputUserInfo = PublishSubject<LoginEntity?>()
    
    override init() {
        super.init()
        setupInput()
    }
    
    func setupInput() {
        inputLoadUserInfo.subscribe(onNext: { [weak self] in
            let loginEntity = self?.userUseCase.loginUserInfo()
            self?.outputUserInfo.onNext(loginEntity)
        }).disposed(by: disposeBag)
    }
}
