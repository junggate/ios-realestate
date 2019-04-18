//
//  MOQuickRegister.swift
//  caramel
//
//  Created by JungMoon-Mac on 03/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import RealmSwift
import HandyJSON

class MOPost: Object, HandyJSON {
    @objc dynamic var id = ""
    @objc dynamic var title = ""
    @objc dynamic var author = ""
    @objc dynamic var link = ""
    @objc dynamic var imgUrl = ""
    @objc dynamic var desc = ""
    @objc dynamic var pubDate = ""
    @objc dynamic var diffDate = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
