//
//  ViewController.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 03/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import JGTabBarView

class PostViewController: UIViewController {
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tabBar: JGTabBarView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let viewModel = PostViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isToday() {
            MainTabBarController.shared?.mainTabBarView?.backgroundColorClear()
        } else {
            MainTabBarController.shared?.mainTabBarView?.backgroundColorBlock()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MainTabBarController.shared?.mainTabBarView?.backgroundColorBlock()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if isToday() {
            return .lightContent
        }
        return .default
    }
    
    func setupUI() {
        setupTabBar()
        
        todayButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.tabBar.selectTab(index: 0)
        }).disposed(by: viewModel.disposeBag)
        
        previousButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.tabBar.selectTab(index: 1)
        }).disposed(by: viewModel.disposeBag)
    }
    
    func setupBinding() {
        
    }
    
    func setupData() {
        
    }
    
    func setupTabBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let postTodayViewController = storyboard.instantiateViewController(withIdentifier: "PostTodayViewController") as? PostTodayViewController else { return }
        guard let postPreviousViewController = storyboard.instantiateViewController(withIdentifier: "PostPreviousViewController") as? PostPreviousViewController else { return }
        
        addChild(postTodayViewController)
        addChild(postPreviousViewController)
        
        postPreviousViewController.headerHeight = headerView.frame.maxY
        postPreviousViewController.tabBarHeight = tabBarController?.tabBar.bounds.height ?? 0.0
        tabBar.tabs = [postTodayViewController, postPreviousViewController]
        tabBar.isHeaderViewHidden = true
        tabBar.tabBarViewDidScroll = { [weak self] (offset) in
            switch offset {
            case ...0.0: // 투데이
                UIView.animate(withDuration: 0.25,
                               animations: { [weak self] in
                                self?.previousButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4), for: .normal)
                                self?.todayButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .selected)
                                self?.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                                MainTabBarController.shared?.mainTabBarView?.backgroundColorClear()
                                self?.view.layoutIfNeeded()
                    },
                               completion: { [weak self] (finish) in
                                self?.todayButton.isSelected = true
                                self?.previousButton.isSelected = false
                                self?.setNeedsStatusBarAppearanceUpdate()
                })
            case ...1.0: // 지난글
                UIView.animate(withDuration: 0.25,
                               animations: { [weak self] in
                                self?.todayButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4), for: .normal)
                                self?.previousButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .selected)
                                self?.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                                MainTabBarController.shared?.mainTabBarView?.backgroundColorBlock()
                                self?.view.layoutIfNeeded()
                    },
                               completion: { [weak self] (finish) in
                                self?.todayButton.isSelected = false
                                self?.previousButton.isSelected = true
                                self?.setNeedsStatusBarAppearanceUpdate()
                })
            default:
                break
            }

        }
//        tabBar.tabBarViewEndScroll = { [weak self] (index) in
//        }
    }
    
    private func isToday() -> Bool {
        return todayButton?.isSelected ?? true
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
