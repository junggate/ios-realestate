//
//  ApiBlogList.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 10/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import HandyJSON

class ApiBlogList: ApiBase {
    override init() {
        super.init()
        url = "\(ApiBase.host)/blogs/\(defaultPostType)"
        method = .get
    }
}

class ApiBlogListRequst: ApiPageRequest {
    var sort: String?
    var order: String?
    
    required init() {}
    
}

class ApiBlogListResponse: ApiPageResponse {
    var blogs: [ApiBlogListblogsResponse]?
    required init() {}
}

class ApiBlogListblogsResponse: ApiPageResponse {
    var name: String?    // 블로그명
    var imgUrl: String?  // 블로그 이미지 url
    var url: String?     // 블로그 url
    required init() {}
}
