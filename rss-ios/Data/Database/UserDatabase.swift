//
//  UserDatabase.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 22/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit

class UserDatabase: NSObject, UserDatabaseGateway {
    let realm = RealmManager.sharedInstance
    
    func loginUser() -> LoginEntity? {
        return realm.select(MOLoginUser.self).first?.toLoginEntity()
    }
    
    func updateLoginUser(loginEntity: LoginEntity) {
        realm.deleteAll(MOLoginUser.self)
        realm.save()
        
        let modelObject = loginEntity.toMOLoginUser()
        realm.insert(modelObject)
        realm.save()
    }

    func logout() {
        realm.deleteRealm()
    }
}
