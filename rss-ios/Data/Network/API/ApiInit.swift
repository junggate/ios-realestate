//
//  ApiInit.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 22/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import HandyJSON

class ApiInit: ApiBase {
    override init() {
        super.init()
        url = "\(ApiBase.host)/hello/\(defaultPostType)"
        method = .get
    }
}

class ApiInitRequst: HandyJSON {
    var deviceToken: String?
    var accessToken: String?
    
    required init() {}
    
}

class ApiInitResponse: HandyJSON {
    var apiVersion: String?
    var access: ApiInitAccessResponse?
    required init() {}
}

class ApiInitAccessResponse: HandyJSON {
    var token: String?
    var expire: Bool?
    var anonymous: Bool?
    required init() {}
}
