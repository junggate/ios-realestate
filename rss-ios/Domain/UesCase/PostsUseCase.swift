//
//  PostsUseCase.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 10/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PostsUseCase: NSObject {
    let disposeBag = DisposeBag()
    
    private let postsNetwork = GatewayBuilder.getPostsNetwork()
    private let postsDatabase = GatewayBuilder.getPostsDatabase()
    
    var postsPageEntity: PageEntity?
    func posts(today: Bool, next: Bool) -> Observable<(page: PageEntity?, entities: [PostEntity?]?)> {
        if next && !(postsPageEntity?.hasNextPage ?? false) {
            return Observable<(page: PageEntity?, entities: [PostEntity?]?)>.create { (observer) -> Disposable in
                observer.onNext((self.postsPageEntity, nil))
                return Disposables.create()
            }
        }
        
        if next == false {
            postsPageEntity = nil
        }
        
        let observable = postsNetwork.posts(isRecent: today, page: postsPageEntity?.getNextPage() ?? 0)
        observable.subscribe(onNext: { [weak self] (result) in
            self?.postsPageEntity = result.page
        }).disposed(by: disposeBag)
        return observable
    }
    
    func savedPost(post: PostEntity) {
        postsDatabase.insertSavedPost(post: post)
    }
    
    func readPost(post: PostEntity) {
        postsDatabase.insertReadPost(post: post)
    }
    
    func getSavedPost() -> [PostEntity?]? {
        return postsDatabase.selectSavedPost()
    }
    
    func getReadPost() -> [PostEntity?]? {
        return postsDatabase.selectReadPost()
    }
    
    func isSavedPost(postId: String) -> Bool {
        return postsDatabase.isSavedPost(postId: postId)
    }
    
    func deleteSavedPost(postId: String) {
        postsDatabase.deleteSavedPost(postId: postId)
    }
}
