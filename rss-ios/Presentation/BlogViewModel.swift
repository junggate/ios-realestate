//
//  BlogViewModel.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 20/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BlogViewModel: NSObject {
    let disposeBag = DisposeBag()
    let blogsUseCase = BlogsUseCase()
    
    let blogEntitiesSubject = BehaviorSubject<[BlogEntity]>(value: [])
    
    // Input
    let inputLoadData = PublishSubject<Void>()
    let inputNextData = PublishSubject<Void>()
    
    // Outout
    let outputRelaodData = PublishSubject<[BlogEntity]?>()
    
    override init() {
        super.init()
        setupInput()
    }
    
    func setupInput() {
        inputLoadData.subscribe(onNext: { [weak self] in
            self?.getData(next: false)
        }).disposed(by: disposeBag)
        
        inputNextData.subscribe(onNext: { [weak self] in
            self?.getData(next: true)
        }).disposed(by: disposeBag)
    }
    
    // Public
    open func getDataCount() -> Int {
        let entities = try? blogEntitiesSubject.value()
        return entities?.count ?? 0
    }
    
    // Private
    func getData(next: Bool) {
        blogsUseCase.blogs(next: next).subscribe(onNext: { [weak self] (result) in
            guard let `self` = self else { return }
            if let nextEntities = result.entities, var entites = try? self.blogEntitiesSubject.value() {
                entites.append(contentsOf: nextEntities)
                self.blogEntitiesSubject.onNext(entites)
            }
        }).disposed(by: disposeBag)
    }
}
