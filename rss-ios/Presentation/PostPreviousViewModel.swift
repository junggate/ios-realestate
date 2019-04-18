//
//  PostPreviousViewModel.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 24/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PostPreviousViewModel: CommonViewModel {
    let postUseCase = PostsUseCase()
    
    let previousPostEntitiesSubject = BehaviorSubject<[Any?]>(value: [])
    let isTodaySubject = BehaviorSubject<Bool>(value: true)
    
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
        if let entities = try? previousPostEntitiesSubject.value() {
            return entities.count
        }
        return 0
    }
    
    // Private
    func getData(next: Bool = false) {
        postUseCase.posts(today: false, next: next).subscribe(onNext: { [weak self] (result) in
            guard let `self` = self else { return }
            var nextEntities: [Any?] = []
            let currentEntites = try? self.previousPostEntitiesSubject.value()
            var lastDate = (currentEntites?.last as? PostEntity)?.pubDate?.toStandardDateFormat()
            result.entities?.forEach({ (postEntity) in
                if let dateString = postEntity?.pubDate?.toStandardDateFormat() {
                    if lastDate != dateString {
                        let dateEntity = DateEntity()
                        dateEntity.date = dateString
                        nextEntities.append(dateEntity)
                        lastDate = dateString
                    }
                    nextEntities.append(postEntity)
                }
            })
            
            //광고 Entity 삽입
            nextEntities.enumerated().forEach({ (object) in
                if object.offset % 10  == 6 {
                    let adEntity = AdEntity()
                    nextEntities.insert(adEntity, at: object.offset)
                }
            })
            
            if var currentEntites = currentEntites, nextEntities.count > 0 {
                currentEntites.append(contentsOf: nextEntities)
                self.previousPostEntitiesSubject.onNext(currentEntites)
            }
        }).disposed(by: disposeBag)
    }
}
