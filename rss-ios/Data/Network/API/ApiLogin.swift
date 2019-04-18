//
//  ApiLogin.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 26/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import HandyJSON

class ApiLogin: ApiBase {
    override init() {
        super.init()
        url = "\(ApiBase.host)/user/\(defaultPostType)/login"
        method = .post
    }
}

class ApiLoginRequst: HandyJSON {
    var socialUserId: String?
    var socialAccessToken: String?
    var socialType: String?
    
    required init() {}
    
}

class ApiLoginResponse: HandyJSON {
    var accessToken: String?
    required init() {}
}
