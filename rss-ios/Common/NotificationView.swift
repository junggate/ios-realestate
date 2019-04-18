//
//  NotificationView.swift
//  ZumMobile
//
//  Created by JungMoon-Mac on 25/07/2018.
//  Copyright © 2018 zuminternet. All rights reserved.
//

import UIKit
import RNNotificationView
import AudioToolbox

class NotificationView: NSObject {
    static func show(title: String?, message: String?, url: String?) {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        RNNotificationView.show(withImage: #imageLiteral(resourceName: "icoSetting"),
                                title: title ?? "집합",
                                message: message ?? "",
                                duration: 10.0) {
        }
    }
}
