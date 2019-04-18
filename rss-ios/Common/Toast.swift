//
//  Toast.swift
//  realreview-iOS
//
//  Created by JungMoon-Mac on 2018. 5. 2..
//  Copyright © 2018년 JungMoon. All rights reserved.
//

import UIKit
import Toast_Swift

class Toast: NSObject {
    static func show(title: String?) {
        guard let title = title else { return }
        var style = ToastStyle()
//        style.messageColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
//        style.backgroundColor  = #colorLiteral(red: 0.1529411765, green: 0.9921568627, blue: 0.8235294118, alpha: 1)
        style.horizontalPadding = 15.0
        style.verticalPadding = 10.0
        style.cornerRadius = 20.0
        ToastManager.shared.style = style
        
        let appDelegate = UIApplication.shared.delegate
        //        appDelegate?.window??.makeToast(title, duration: 3.0, point: CGPoint(x: 100, y: 100), style: style)
        
        if let window = appDelegate?.window {
            if let window = window {
                var safeAreaBottom: CGFloat = 0.0
                if #available(iOS 11, *) {
                    safeAreaBottom = window.safeAreaInsets.bottom
                }
                
                window.hideAllToasts()
                window.makeToast(title,
                                 point: CGPoint(x: window.frame.size.width/2.0,
                                                y: window.frame.size.height-(80+safeAreaBottom)),
                                 title: nil,
                                 image: nil,
                                 completion: nil)
            }
        }
        
    }
}
