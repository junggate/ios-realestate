//
//  BlogGateway.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 20/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol BlogsNetworkGateway {
    func blogs(page: Int) -> Observable<(page: PageEntity?, entities: [BlogEntity]?)>
}
