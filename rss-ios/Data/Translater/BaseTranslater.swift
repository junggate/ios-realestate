//
//  BaseTranslater.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 22/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import HandyJSON

extension HandyJSON {
    func toEntity<T: Decodable>(entityType: T.Type) -> T? {
        let decoder = JSONDecoder()
        if let data = self.toJSONString()?.data(using: .utf8),
            let entity = try? decoder.decode(entityType.self, from: data) {
            return entity
        }
        return nil
    }
}
