//
//  GatewayBuilder.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 10/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GatewayBuilder: NSObject {
    static func getPostsNetwork() -> PostsNetworkGateway {
        return PostsNetwork()
    }
    
    static func getBlogsNetwork() -> BlogsNetworkGateway {
        return BlogsNetwork()
    }
    
    static func getPostsDatabase() -> PostDatabaseGateway {
        return PostDatabase()
    }
    
    static func getUserNetwork() -> UserNetworkGateway {
        return UserNetwork()
    }
    
    static func getUserDatabase() -> UserDatabaseGateway {
        return UserDatabase()
    }
}
