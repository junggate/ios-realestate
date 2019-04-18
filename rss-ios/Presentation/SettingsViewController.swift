//
//  SettingsViewController.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 06/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsViewController: UIViewController {
    @IBOutlet weak var logoutHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var termButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var versionButton: UIButton!
    @IBOutlet weak var opensourceButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var logoutViewHeightConstrinat: NSLayoutConstraint!
    
    let viewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
        setupData()
    }
    
    func setupUI() {
        // let bundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        if let stringVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "\(stringVersion)"
        }

        closeButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: viewModel.disposeBag)
        
        logoutButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.viewModel.inputLogout.onNext(())
        }).disposed(by: viewModel.disposeBag)
        
        termButton.rx.tap.subscribe(onNext: { [weak self] in
//            let fileUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "terms", ofType: "html")!)
            let url = URL(string: "https://ryudung.com/terms")
            self?.moveWebViewController(title: "서비스 이용약관", url: url)
        }).disposed(by: viewModel.disposeBag)
        
        privacyButton.rx.tap.subscribe(onNext: { [weak self] in
//            let fileUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "privacy", ofType: "html")!)
            let url = URL(string: "https://ryudung.com/terms/privacy")
            self?.moveWebViewController(title: "개인정보처리방침", url: url)
        }).disposed(by: viewModel.disposeBag)
        
        opensourceButton.rx.tap.subscribe(onNext: { [weak self] in
            let fileUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "license", ofType: "html")!)
            self?.moveWebViewController(title: "오픈소스 라이센스", url: fileUrl)
        }).disposed(by: viewModel.disposeBag)
    }
    
    func setupBinding() {
        viewModel.outputLogoutHidden.subscribe(onNext: { [weak self] (hidden) in
            self?.logoutHeightConstraint.constant = hidden ? 0.0 : 64.0
        }).disposed(by: viewModel.disposeBag)
        
        viewModel.outputLogoutCompleted.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
            Toast.show(title: "로그아웃되었습니다.")
        }).disposed(by: viewModel.disposeBag)
    }
    
    func setupData() {
        viewModel.inputCheckLogin.onNext(())
    }
    
    func moveWebViewController(title: String?, url: URL?) {
        if let webViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as? WebViewController {
            webViewController.title = title
            webViewController.url = url
            navigationController?.pushViewController(webViewController, animated: true)
        }
    }
}
