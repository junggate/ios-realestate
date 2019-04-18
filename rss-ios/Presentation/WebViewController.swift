//
//  OpensourceViewController.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 06/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    let disposeBag = DisposeBag()
    var observer: NSKeyValueObservation?

    open var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
        setupData()
    }
    
    func setupUI() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        closeButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    func setupBinding() {
        
    }
    
    func setupData() {
        titleLabel.text = title
        
        observer = webView.observe(\.estimatedProgress) { [weak self] (webView, change) in
            guard let `self` = self else { return }
            let progress = Float(webView.estimatedProgress)
            if self.progressView.progress < progress {
                self.progressView.setProgress(progress, animated: true)
            }
        }
        
        if let url = url {
            webView.load(URLRequest(url: url))
        }

    }
}

extension WebViewController {
    //WKNavigationDelegate
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(0) + .milliseconds(500)) { [weak self] in
            self?.progressView.isHidden = true
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
        progressView.progress = 0.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("scroll \(scrollView.contentOffset.y)")
        //        if scrollView.contentOffset.y <= 0 {
        //            self.contentTopConstraint.constant -= scrollView.contentOffset.y
        //            scrollView.contentOffset.y = 0
        //        } else {
        //            self.contentTopConstraint.constant -= scrollView.contentOffset.y
        //            scrollView.contentOffset.y = 0
        //        }
    }
}
