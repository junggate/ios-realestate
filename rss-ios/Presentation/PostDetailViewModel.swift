//
//  PostDetailViewModel.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 01/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PostDetailViewModel: CommonViewModel {
    var postEntity: PostEntity?
    let postsUseCase = PostsUseCase()
    
    // Input
    let inputSavePost = PublishSubject<Bool>()
    let inputCheckSavedPost = PublishSubject<Void>()
    
    // Output
    let outputSavedPost = PublishSubject<Void>()
    
    override init() {
        super.init()
        setupInput()
    }
    
    func setupInput() {
        inputSavePost.subscribe(onNext: { [weak self] (save) in
            if let postEntity = self?.postEntity {
                if save {
                    self?.postsUseCase.savedPost(post: postEntity)
                    self?.outputToast.onNext("포스트가 저장되었습니다.")
                } else if let postId = postEntity.id {
                    self?.postsUseCase.deleteSavedPost(postId: postId)
                }
            }
        }).disposed(by: disposeBag)
        
        inputCheckSavedPost.subscribe(onNext: { [weak self] in
            if let postId = self?.postEntity?.id {
                if self?.postsUseCase.isSavedPost(postId: postId) ?? false {
                    self?.outputSavedPost.onNext(())
                }
            }
        }).disposed(by: disposeBag)
    }
}
