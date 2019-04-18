//
//  MyPostViewModel.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 05/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyPostViewModel: NSObject {
    let disposeBag = DisposeBag()
    let postUseCase = PostsUseCase()
    
    let postEntitiesSubject = BehaviorSubject<[PostEntity?]?>(value: [])
    
    override init() {
        super.init()
        setupInput()
    }
    
    func setupInput() {
        
    }
    
    func getDataCount() -> Int {
        let entities = try? postEntitiesSubject.value()
        guard let count = entities??.count else { return 0 }
        return count
    }
    
    func getData() {
        
    }
}
