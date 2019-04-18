//
//  PostsTranslater.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 10/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import HandyJSON

extension ApiPostListResponse {
    func toPostEntities() -> [PostEntity?]? {
        return self.posts?.map({ (apiPostListPostsResponse) -> PostEntity? in
            return apiPostListPostsResponse.toPostEntity()
        })
    }
}

extension ApiPostListPostsResponse {
    func toPostEntity() -> PostEntity? {
        let decoder = JSONDecoder()
        if let data = self.toJSONString()?.data(using: .utf8),
            let postEntity = try? decoder.decode(PostEntity.self, from: data) {
            postEntity.desc = description
            return postEntity
        }
        return nil
    }
}

extension PostEntity {
    func toMOSavedPost() -> MOSavedPost {
        let savedPost = MOSavedPost()
        toMOPost(post: savedPost)
        return savedPost
    }
    
    func toMOReadPost() -> MOReadPost {
        let readPost = MOReadPost()
        toMOPost(post: readPost)
        return readPost
    }

    private func toMOPost(post: MOPost) {
        post.id = id ?? ""
        post.title = title ?? ""
        post.author = author ?? ""
        post.link = link ?? ""
        post.imgUrl = imgUrl ?? ""
        post.desc = desc ?? ""
        post.pubDate = pubDate ?? ""
        post.diffDate = diffDate ?? ""
    }
}

extension MOPost {
    func toPost() -> PostEntity? {
        let decoder = JSONDecoder()
        print("self.toJSONString() \(self.toJSONString()!)")
        if let data = self.toJSONString()?.data(using: .utf8),
            let postEntity = try? decoder.decode(PostEntity.self, from: data) {
            return postEntity
        }
        return nil
    }
}
