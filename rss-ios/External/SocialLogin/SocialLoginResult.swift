//
//  VOLoginResult.swift
//  realreview-iOS
//
//  Created by JungMoon-Mac on 2018. 4. 11..
//  Copyright © 2018년 JungMoon. All rights reserved.
//

import UIKit

class SocialLoginResult: NSObject {
    var `id`:String?
    var email: String?
    var name: String?
    var profileImage: String?
    var accessToken: String?
    var socialType: String?
    
    override var description: String {
        return """
               \(super.description)
               id : \(id ?? "")
               email : \(email ?? "")
               profileImage : \(profileImage ?? "")
               accessToken : \(accessToken ?? "")
               socialType : \(socialType ?? "")
               """
    }
}
