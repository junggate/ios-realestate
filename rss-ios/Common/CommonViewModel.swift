//
//  CommonViewMode.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 09/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CommonViewModel: NSObject {
    let disposeBag = DisposeBag()
    var defaultError: ((Error) -> Void)?
    
    // Input
    
    // Ouput
    let outputToast = PublishSubject<String?>()
    
    override init() {
        super.init()
        
        outputToast.subscribe(onNext: { (text) in
            if let text = text {
                Toast.show(title: text)
            }
        }).disposed(by: disposeBag)
        
        defaultError = { [weak self] (error) in
            self?.outputToast.onNext(error.localizedDescription)
        }
    }
}
