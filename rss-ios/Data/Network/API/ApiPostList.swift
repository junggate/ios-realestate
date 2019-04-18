//
//  ApiPostList.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 10/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import HandyJSON

class ApiPostList: ApiBase {
    override init() {
        super.init()
        url = "\(ApiBase.host)/posts/\(defaultPostType)"
        method = .get
    }
}

class ApiPostListRequst: ApiPageRequest {
    var sort: String?
    var order: String?
    var isRecent: String?
    required init() {}
    
}

class ApiPostListResponse: ApiPageResponse {
    var posts: [ApiPostListPostsResponse]?
    required init() {}
}

class ApiPostListPostsResponse: ApiPageResponse {
    var `id`: String?          //타이틀
    var title: String?          //타이틀
    var author: String?         //저자
    var link: String?         //저자
    var imgUrl: String?         //이미지 url 없을 수도 있음
    var description: String?    //설명
    var pubDate: String?        //발행 날짜
    var diffDate: String?       //오늘과 비교한 날짜
    required init() {}
}
