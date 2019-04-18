//
//  MOLoginUser.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 22/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import RealmSwift

class MOLoginUser: Object {
    @objc dynamic var socialUserId = ""
    @objc dynamic var socialAccessToken = ""
    @objc dynamic var socialType = ""
    @objc dynamic var deviceToken = ""
    
    @objc dynamic var apiVersion = ""
    @objc dynamic var accessToken = ""
    @objc dynamic var anonymous = true
    
    @objc dynamic var name = ""
    @objc dynamic var profileUrl = ""
    
}
