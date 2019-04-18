//
//  ShareViewController.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 23/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ShareViewController: UIViewController {

    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var kakaoButton: UIButton!
    @IBOutlet weak var linkCopyButton: UIButton!
    @IBOutlet weak var bgButton: UIButton!
    
    let splashImageUrl = "https://firebasestorage.googleapis.com/v0/b/rss-project-e64a4.appspot.com/o/00_splash_1.png?alt=media&token=36ba9b36-dfbd-4d8e-958a-be8001812e58"
    open var linkTitle: String?
    open var linkUrl: String?
    open var sharedComplete: (() -> Void)?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
        setupData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: { [weak self] in
                        self?.view.alpha = 1.0
            },
                       completion: { (finish) in
                        
        })
    }

    func setupUI() {
        view.alpha = 0.0
        
        facebookButton.rx.tap.subscribe(onNext: { [weak self] in
            SocialShareFacebook().share(title: self?.linkTitle ?? "",
                                        imageUrl: self?.splashImageUrl ?? "",
                                        linkUrl: self?.linkUrl ?? "")
            self?.dismiss(completed: self?.sharedComplete)
        }).disposed(by: disposeBag)
        
        kakaoButton.rx.tap.subscribe(onNext: { [weak self] in
            SocialShareKakaoTalk().share(title: self?.linkTitle ?? "",
                                         imageUrl: self?.splashImageUrl ?? "",
                                         linkUrl: self?.linkUrl ?? "")
            self?.dismiss(completed: self?.sharedComplete)
        }).disposed(by: disposeBag)
        
        linkCopyButton.rx.tap.subscribe(onNext: { [weak self] in
            let pasteBoard = UIPasteboard.general
            pasteBoard.string = self?.linkUrl ?? ""
            Toast.show(title: "클립보드에 저장되었습니다.")
            self?.bgButton.sendActions(for: UIControl.Event.touchUpInside)
        }).disposed(by: disposeBag)
        
        bgButton.rx.tap.subscribe(onNext: { [weak self] in
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           options: UIView.AnimationOptions.curveEaseInOut,
                           animations: { [weak self] in
                            self?.view.alpha = 0.0
                },
                           completion: { [weak self] (finish) in
                            self?.dismiss(animated: false, completion: nil)
                            
            })
        }).disposed(by: disposeBag)
    }
    
    func setupBinding() {
        
    }
    
    func setupData() {
        
    }
    
    private func dismiss(completed: (() -> Void)?) {
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: { [weak self] in
                        self?.view.alpha = 0.0
            },
                       completion: { [weak self] (finish) in
//                        self?.dismiss(animated: false, completion: )
                        self?.dismiss(animated: false, completion: { [weak self] in
                            self?.sharedComplete?()
                        })
        })

    }
}
