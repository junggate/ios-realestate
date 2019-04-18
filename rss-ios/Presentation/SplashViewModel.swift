//
//  SplashViewModel.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 26/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SplashViewModel: CommonViewModel {
    let userUseCase = UserUseCase()
    
    // Input
    let inputApiInit = PublishSubject<String?>()
    
    // Output
    let outputMoveMain = PublishSubject<Void>()
    
    override init() {
        super.init()
        setupInput()
    }
    
    func setupInput() {
        inputApiInit
            .subscribe(onNext: { [weak self] (deviceToken) in
                var dispose: Disposable?
                dispose = self?.userUseCase.init(deviceToken: deviceToken)
                    .subscribe(onNext: { [weak self] (loginEntity) in
                        self?.outputMoveMain.onNext(())
                        dispose?.dispose()
                        },
                               onError: { (error) in
                                
                    })
                
            }).disposed(by: disposeBag)
    }
}
