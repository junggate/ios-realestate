//
//  ApiLogout.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 30/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import HandyJSON

class ApiLogout: ApiBase {
    override init() {
        super.init()
        url = "\(ApiBase.host)/user/logout"
        method = .get
    }
}

class ApiLogoutRequst: HandyJSON {
    required init() {}
}

class ApiLogoutResponse: HandyJSON {
    var logoutSuccess: String?
    required init() {}
}
