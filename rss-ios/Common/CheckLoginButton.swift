//
//  CheckLoginButton.swift
//  lalla
//
//  Created by JungMoon-Mac on 21/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CheckLoginButton: UIButton {
    var allTargetsList: [(target: Any?, selector: Selector?)] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for target in allTargets {
            if let actionList = actions(forTarget: target, forControlEvent: UIControl.Event.touchUpInside) {
                for action in actionList {
                    allTargetsList.append((target, NSSelectorFromString(action)))
                    removeTarget(target, action: NSSelectorFromString(action), for: UIControl.Event.touchUpInside)
                }
            }
        }
        
        super.addTarget(self, action: #selector(touchCheckLogin), for: UIControl.Event.touchUpInside)
    }
    
    override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        allTargetsList.append((target, action))
    }
    
    @objc func touchCheckLogin() {
        if UserUseCase().isLogin() == false {
            Toast.show(title: "로그인이 필요합니다.")
            if let navigationViewController = UIApplication.shared.delegate?.window??.rootViewController as? UINavigationController,
                let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                navigationViewController.pushViewController(loginViewController, animated: true)
            }
        } else {
            setTargetList()
        }
    }
    
    private func setTargetList() {
        for object in allTargetsList {
            if let selector = object.selector {
                super.addTarget(object.target, action: selector, for: UIControl.Event.touchUpInside)
                sendAction(selector, to: object.target, for: nil)
            }
        }
        
        allTargetsList.removeAll()
    }
}
