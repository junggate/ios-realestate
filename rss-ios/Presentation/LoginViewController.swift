//
//  LoginViewController.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 02/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var kakaoButton: UIButton!
    @IBOutlet weak var naverButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
        setupData()
    }

    func setupUI() {
        backButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: viewModel.disposeBag)
    }
    
    func setupBinding() {
        viewModel.inputKakaoRegister = kakaoButton.rx.tap.asDriver()
        viewModel.inputFacebookRegister = facebookButton.rx.tap.asDriver()
        viewModel.inputNaverRegister = naverButton.rx.tap.asDriver()
        
        viewModel.outputLoginComplete.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: viewModel.disposeBag)
    }
    
    func setupData() {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
