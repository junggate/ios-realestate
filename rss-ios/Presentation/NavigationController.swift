//
//  NavigationController.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 07/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBinding()
        setupData()
        
    }
    
    func setupUI() {
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func setupBinding() {
        
    }
    
    func setupData() {
        
    }
}
