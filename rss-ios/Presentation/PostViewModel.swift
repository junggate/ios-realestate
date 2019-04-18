//
//  PostViewModel.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 14/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import JGExtension

class PostViewModel: NSObject {
    let disposeBag = DisposeBag()
    let postUseCase = PostsUseCase()
    
    // Input
    
    // Outout
    
    override init() {
        super.init()
        setupInput()
    }
    
    func setupInput() {
    }
}
