//
//  PostEntity.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 10/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit

class PostEntity: NSObject, Codable {
    var `id`: String?           //id
    var title: String?          //타이틀
    var author: String?         //저자
    var link: String?           //링크
    var imgUrl: String?         //이미지 url 없을 수도 있음
    var desc: String?           //설명
    var pubDate: String?        //발행 날짜
    var diffDate: String?       //오늘과 비교한 날짜
}
