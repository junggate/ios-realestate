//
//  MyViewController.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 19/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import JGTabBarView
import RxSwift
import RxCocoa
import SDWebImage

class MyViewController: UIViewController {
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var tabBar: JGTabBarView!
    @IBOutlet weak var tabReadButton: MyTabButton!
    @IBOutlet weak var tabSavedButton: MyTabButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileLabel: UILabel!
    
    let viewModel = MyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputLoadUserInfo.onNext(())
    }
    
    func setupUI() {
        guard let readPostViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyPostViewController") as? MyPostViewController else { return }
        
        guard let savedPostViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyPostViewController") as? MyPostViewController else { return }
        
        readPostViewController.tabTitle = "내가 읽은 글"
        savedPostViewController.tabTitle = "저장된 글"
        
        readPostViewController.noDataTitle = "읽은 글이 없습니다."
        savedPostViewController.noDataTitle = "저장된 글이 없습니다."
        
        readPostViewController.viewModel = MyReadPostViewModel()
        savedPostViewController.viewModel = MySavedPostViewModel()
        
        addChild(readPostViewController)
        addChild(savedPostViewController)
        
        tabBar.tabs = [readPostViewController, savedPostViewController]
        tabBar.isHeaderViewHidden = true
        tabBar.tabBarViewDidScroll = { [weak self] (index) in
            self?.tabReadButton.isSelected = false
            self?.tabSavedButton.isSelected = false
            if index == 0 {
                self?.tabReadButton.isSelected = true
            } else {
                self?.tabSavedButton.isSelected = true
            }
        }
        
    }
    
    func setupBinding() {
        profileButton.rx.tap.subscribe(onNext: { // [weak self] in
            MainTabBarController.shared?.performSegue(withIdentifier: "login", sender: nil)
        }).disposed(by: viewModel.disposeBag)
        
        tabReadButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.tabBar.selectTab(index: 0)
        }).disposed(by: viewModel.disposeBag)
        
        tabSavedButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.tabBar.selectTab(index: 1)
        }).disposed(by: viewModel.disposeBag)
        
        viewModel.outputUserInfo.subscribe(onNext: { [weak self] (loginEntity) in
            if let loginEntity = loginEntity, loginEntity.anonymous == false {
                if let profileUrl = loginEntity.profileUrl {
                    self?.profileImageView.sd_setImage(with: URL(string: profileUrl),
                                                       placeholderImage: #imageLiteral(resourceName: "defaultProfile"),
                                                       options: SDWebImageOptions.highPriority,
                                                       completed: nil)
                }
                self?.profileLabel.text = "\(loginEntity.name ?? "사용자")님\n반갑습니다."
                self?.profileButton.isHidden = true
            } else { // 로그아웃 상태
                self?.profileButton.isHidden = false
                self?.profileImageView.image = #imageLiteral(resourceName: "defaultProfile")
                self?.profileLabel.text = "로그인\n해주세요."
            }
        }).disposed(by: viewModel.disposeBag)
    }
    
    func setupData() {
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

}
