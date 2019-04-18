//
//  String+Extension.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 01/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.date(from: self)
    }
    
    func toStandardDateFormat() -> String? {
        if let date = toDate() {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy년 MM월 dd일"
            return formatter.string(from: date)
        }
        return nil
    }
    
    func toStandardDateTimeFormat() -> String? {
        if let date = toDate() {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM월 dd일 HH시 mm분"
            return formatter.string(from: date)
        }
        return nil
    }
}
