//
//  ApiPage.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 10/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import HandyJSON

class ApiPageRequest: HandyJSON {
    var page: Int = 0
    var size: Int = 0
    
    required init() {}
}

class ApiPageResponse: HandyJSON {
    var currentPage: Int = 0
    var hasNextPage: Bool = false

    required init() {}
}
