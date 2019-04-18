//
//  SplashViewController.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 26/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SplashViewController: UIViewController {
    let viewModel = SplashViewModel()
    
    open var deviceToken: String? {
        didSet {
            viewModel.inputApiInit.onNext(deviceToken)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
        setupData()
    }
    
    func setupUI() {
        
    }
    
    func setupBinding() {
        viewModel.outputMoveMain.subscribe(onNext: { [weak self] in
            let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController")
            self?.navigationController?.setViewControllers([tabBarController], animated: true)
        }).disposed(by: viewModel.disposeBag)
    }
    
    func setupData() {
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
