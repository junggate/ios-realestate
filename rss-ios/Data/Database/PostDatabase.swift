//
//  UserDatabase.swift
//  caramel
//
//  Created by JungMoon-Mac on 05/11/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit

class PostDatabase: PostDatabaseGateway {    
    let realm = RealmManager.sharedInstance
    
    func insertReadPost(post: PostEntity) {
        if let readPost = selectMOReadPost()?.filter({ (readPost) -> Bool in
            return readPost.title == post.title
        }).first {
            realm.delete(readPost)
            realm.save()
        }
        realm.insert(post.toMOReadPost())
        realm.save()
    }
    
    func insertSavedPost(post: PostEntity) {
        if let savedPost = selectMOSavedPost()?.first, savedPost.id == post.id {
            realm.delete(savedPost)
            realm.save()
        }
        realm.insert(post.toMOSavedPost())
        realm.save()
    }
    
    func deleteSavedPost(postId: String) {
        if let savedPost = selectMOSavedPost()?.filter({ (post) -> Bool in
            return post.id == postId
        }).first {
            realm.delete(savedPost)
            realm.save()
        }
    }

    func selectReadPost() -> [PostEntity?]? {
        return realm.select(MOReadPost.self).map({ (post) -> PostEntity? in
            return post.toPost()
        }).sorted(by: { (post1, post2) -> Bool in
            let post1Interval = post1?.pubDate?.toDate()?.timeIntervalSinceNow ?? 0
            let post2Interval = post2?.pubDate?.toDate()?.timeIntervalSinceNow ?? 0
            return post1Interval > post2Interval
        })
    }
    
    func selectSavedPost() -> [PostEntity?]? {
        return realm.select(MOSavedPost.self).map({ (post) -> PostEntity? in
            return post.toPost()
        }).sorted(by: { (post1, post2) -> Bool in
            let post1Interval = post1?.pubDate?.toDate()?.timeIntervalSinceNow ?? 0
            let post2Interval = post2?.pubDate?.toDate()?.timeIntervalSinceNow ?? 0
            return post1Interval > post2Interval
        })
    }
    
    func isSavedPost(postId: String) -> Bool {
        if selectMOSavedPost()?.filter({ (post) -> Bool in
            return post.id == postId
        }).first != nil {
            return true
        }
        return false
    }
    
    private func selectMOReadPost() -> [MOReadPost]? {
        return realm.select(MOReadPost.self).map({ (post) -> MOReadPost in
            return post
        })
    }
    
    private func selectMOSavedPost() -> [MOSavedPost]? {
        return realm.select(MOSavedPost.self).map({ (post) -> MOSavedPost in
            return post
        })
    }
}
