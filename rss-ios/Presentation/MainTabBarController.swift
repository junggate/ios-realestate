//
//  MainTabBarController.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 19/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    static var shared: MainTabBarController?
    
    var mainTabBarView: MainTabBarView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        MainTabBarController.shared = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
        setupData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupMainTabBar()
    }
    
    func setupUI() {
        selectedIndex = 1
        tabBar.alpha = 0.0
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func setupBinding() {
        
    }
    
    func setupData() {
        
    }
    
    func setupMainTabBar() {
        if mainTabBarView == nil, let mainTabBarView = Bundle.main.loadNibNamed("MainTabBarView", owner: self, options: nil)?.first as? MainTabBarView {
            view.addSubview(mainTabBarView)
            let safeBottom = view.safeAreaInsets.bottom
            
            mainTabBarView.translatesAutoresizingMaskIntoConstraints = false
            view.rightAnchor.constraint(equalTo: mainTabBarView.rightAnchor).isActive = true
            view.leftAnchor.constraint(equalTo: mainTabBarView.leftAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: mainTabBarView.bottomAnchor, constant: 0).isActive = true
            mainTabBarView.heightAnchor.constraint(equalToConstant: 49 + safeBottom).isActive = true
            mainTabBarView.selectClosure = { [weak self] (index) in
                self?.selectedIndex = index
            }
            self.mainTabBarView = mainTabBarView
        }
    }
    
    override var selectedIndex: Int {
        didSet {
            mainTabBarView?.selectedIndex = selectedIndex
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let count = viewControllers?.count, count-1 > selectedIndex {
            return viewControllers?[selectedIndex].preferredStatusBarStyle ?? .lightContent
        }
        
        return .lightContent
    }
}
