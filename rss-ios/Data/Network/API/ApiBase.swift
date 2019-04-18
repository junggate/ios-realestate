//
//  ApiBase.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 10/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import Alamofire

let defaultPostType = "real_estate"

class ApiBase: NSObject {
    static let host = "https://www.ryudung.com"
    static let serviceType = "real_estate"
    static var accessToken: String?
    var url = ""
    var method: HTTPMethod = HTTPMethod.get
    var pathValues: [String: String]?
    var apiToken: String?
    
    func getUrl() -> URL {
        if let pathValues = pathValues {
            pathValues.forEach { [weak self] (item) in
                self?.replaceVariablePath(varKey: item.key, value: item.value)
            }
        }
        
        return URL(string: url)!
    }
    
    private func replaceVariablePath(varKey: String, value: String) {
        url = url.replacingOccurrences(of: "{\(varKey)}", with: value)
    }

}
