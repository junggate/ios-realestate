//
//  ProposalViewController.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 21/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import JGWebView
class ProposalViewController: UIViewController {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var webView: JGWebView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBinding()
        setupData()
        
    }
    
    func setupUI() {
        closeButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    func setupBinding() {
        
    }
    
    func setupData() {
        let urlString = "https://docs.google.com/forms/d/e/1FAIpQLScsGG8JwCi92KoE6lqbSa8wl1zNkT9ERDAnxNgM20LxIgWzWw/viewform"
        webView.load(URLRequest(url: URL(string: urlString)!))
    }
}
