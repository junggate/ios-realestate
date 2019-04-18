//
//  CursorTranslater.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 01/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import HandyJSON

extension ApiPageResponse {
    func toPage() -> PageEntity? {
        let decoder = JSONDecoder()
        if let data = self.toJSONString()?.data(using: .utf8),
            let pageEntity = try? decoder.decode(PageEntity.self, from: data) {
            return pageEntity
        }
        return nil
        
    }
    
}
