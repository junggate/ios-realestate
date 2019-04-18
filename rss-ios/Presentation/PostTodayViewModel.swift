//
//  PostTodayViewModel.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 24/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PostTodayViewModel: CommonViewModel {
    let postUseCase = PostsUseCase()
    
    let todayPostEntitiesSubject = BehaviorSubject<[PostEntity?]>(value: [])
    let dataCountSubject = BehaviorSubject<Int>(value: 0)
    
    // Input
    let inputLoadData = PublishSubject<Bool>()
    let inputPostEntity = PublishSubject<PostEntity>()
    
    // Outout
    let outputRelaodData = PublishSubject<[PostEntity?]?>()
    
    override init() {
        super.init()
        setupInput()
    }
    
    func setupInput() {
        inputLoadData.subscribe(onNext: { [weak self] (next) in
            self?.getData(next: next)
        }).disposed(by: disposeBag)
        
        inputPostEntity.subscribe(onNext: { [weak self] (post) in
            self?.postUseCase.readPost(post: post)
        }).disposed(by: disposeBag)
    }
    
    // Public
    public func getDataCount() -> Int {
        if let entities = try? todayPostEntitiesSubject.value() {
            return entities.count
        }
        return 0
    }
    
    // Private
    func getData(next: Bool = false) {
        postUseCase.posts(today: true, next: next)
            .subscribe(
                onNext: { [weak self] (result) in
                    guard let `self` = self else { return }
                    if let nextEntities = result.entities, var entites = try? self.todayPostEntitiesSubject.value() {
                        entites.append(contentsOf: nextEntities)
                        self.todayPostEntitiesSubject.onNext(entites)
                    }
                },
                onError: defaultError)
            .disposed(by: disposeBag)
    }
    
}
