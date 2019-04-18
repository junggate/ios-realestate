//
//  LoginEntity.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 22/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit

class LoginEntity: NSObject, Codable {
    var apiVersion: String?
    var token: String? // accessToken
    var expire: Bool?
    var anonymous: Bool?
    
    var socialUserId: String?
    var socialAccessToken: String?
    var socialType: String?
    var deviceToken: String?

    var name: String?
    var profileUrl: String?
}
