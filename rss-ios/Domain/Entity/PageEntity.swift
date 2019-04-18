//
//  PageEntity.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 01/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit

class PageEntity: NSObject, Codable {
    var currentPage: Int = 0
    var hasNextPage: Bool = false
    
    func getNextPage() -> Int {
        if hasNextPage {
            return currentPage+1
        }
        return 0
    }
}
