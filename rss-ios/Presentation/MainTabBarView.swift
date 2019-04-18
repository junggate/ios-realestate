//
//  MainTabBarView.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 19/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainTabBarView: UIView {
    @IBOutlet weak var blogButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var myButton: UIButton!
  
    let disposeBag = DisposeBag()
    
    open var selectClosure: ((Int) -> Void)?
    
    override func awakeFromNib() {
        blogButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.selectClosure?(0)
            self?.selectedButton(button: self?.blogButton)
        }).disposed(by: disposeBag)
        
        homeButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.selectClosure?(1)
            self?.selectedButton(button: self?.homeButton)
        }).disposed(by: disposeBag)
        
        myButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.selectClosure?(2)
            self?.selectedButton(button: self?.myButton)
        }).disposed(by: disposeBag)
    }
    
    open var selectedIndex: Int = 1 {
        didSet {
            blogButton.isSelected = false
            homeButton.isSelected = false
            myButton.isSelected = false
            
            switch selectedIndex {
            case 0:
                selectedButton(button: blogButton)
            case 1:
                selectedButton(button: homeButton)
            case 2:
                selectedButton(button: myButton)
            default :
                break
            }
        }
    }
    
    open func backgroundColorBlock() {
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    open func backgroundColorClear() {
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    private func selectedButton(button: UIButton?) {
        blogButton.isSelected = false
        homeButton.isSelected = false
        myButton.isSelected = false
        button?.isSelected = true
    }
}
