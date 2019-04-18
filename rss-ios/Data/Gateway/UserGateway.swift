//
//  UserGateway.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 22/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol UserNetworkGateway {
    func `init`(deviceToken: String?, accessToken: String?) -> Observable<LoginEntity?>
    func login(socialUserId: String?,
               socialAccessToken: String?,
               socialType: String?) -> Observable<String?>
    func logout() -> Observable<String?>
}

protocol UserDatabaseGateway {
    func loginUser() -> LoginEntity?
    func updateLoginUser(loginEntity: LoginEntity)
    func logout()
}
