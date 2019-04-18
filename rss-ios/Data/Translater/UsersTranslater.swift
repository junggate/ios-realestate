//
//  UsersTranslater.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 22/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit

extension ApiInitResponse {
    func toLoginEntities() -> LoginEntity? {
        let entity = self.toEntity(entityType: LoginEntity.self)
        entity?.token = access?.token
        entity?.expire = access?.expire
        entity?.anonymous = access?.anonymous
        return entity
    }
}

extension LoginEntity {
    func toMOLoginUser() -> MOLoginUser {
        let moLoginUser = MOLoginUser()
        moLoginUser.socialUserId = socialUserId ?? ""
        moLoginUser.socialAccessToken = socialAccessToken ?? ""
        moLoginUser.socialType = socialType ?? ""
        moLoginUser.deviceToken = deviceToken ?? ""
        moLoginUser.apiVersion = apiVersion ?? ""
        moLoginUser.accessToken = token ?? ""
        moLoginUser.anonymous = anonymous ?? true
        moLoginUser.name = name ?? ""
        moLoginUser.profileUrl = profileUrl ?? ""
        return moLoginUser
    }
}

extension MOLoginUser {
    func toLoginEntity() -> LoginEntity {
        let loginEntity = LoginEntity()
        loginEntity.socialUserId = socialUserId
        loginEntity.socialAccessToken = socialAccessToken
        loginEntity.socialType = socialType
        loginEntity.deviceToken = deviceToken
        loginEntity.apiVersion = apiVersion
        loginEntity.token = accessToken
        loginEntity.anonymous = anonymous
        loginEntity.name = name
        loginEntity.profileUrl = profileUrl
        return loginEntity
    }
}
