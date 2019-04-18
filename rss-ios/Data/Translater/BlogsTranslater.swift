//
//  BlogsTranslater.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 20/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit

extension ApiBlogListResponse {
    func toBlogEntities() -> [BlogEntity]? {
        return blogs?.map({ (apiBlogListblogsResponse) -> BlogEntity in
            return apiBlogListblogsResponse.toBlogEntity()
        })
    }
}

extension ApiBlogListblogsResponse {
    func toBlogEntity() -> BlogEntity {
        let blogEntity = BlogEntity()
        blogEntity.name = name
        blogEntity.url = url
        blogEntity.imgUrl = imgUrl
        return blogEntity
    }
}
