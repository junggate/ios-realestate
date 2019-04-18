//
//  PostsGateway.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 10/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol PostsNetworkGateway {
    func posts(isRecent: Bool, page: Int) -> Observable<(page: PageEntity?, entities: [PostEntity?]?)>
}

protocol PostDatabaseGateway {
    func insertReadPost(post: PostEntity)
    func insertSavedPost(post: PostEntity)
    func selectReadPost() -> [PostEntity?]?
    func selectSavedPost() -> [PostEntity?]?
    func isSavedPost(postId: String) -> Bool
    func deleteSavedPost(postId: String)
}
