//
//  FeedDetailViewController.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 07/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import WebKit

class PostDetailViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var etcButton: UIButton!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var openPostButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var webContentView: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var bottomCloseButton: UIButton!
    let viewModel = PostDetailViewModel()
    
    open var postEntity: PostEntity? {
        didSet {
            viewModel.postEntity = postEntity
        }
    }
    
    var observer: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
        setupData()
    }
    
    override func viewWillLayoutSubviews() {
        
    }
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        openAnimation()
    }
    
    func setupUI() {
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.scrollView.delegate = self
        
        contentTopConstraint.constant = contentView.bounds.height + view.safeAreaInsets.bottom
        view.layoutIfNeeded()
        closeButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.closeAnimation()
        }).disposed(by: viewModel.disposeBag)
        
        bottomCloseButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.closeAnimation()
        }).disposed(by: viewModel.disposeBag)
        
        openPostButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.webContentView.isHidden = false
            self?.backButton.isHidden = false
            if let urlString = self?.postEntity?.link, let url = URL(string: urlString) {
                self?.webView.load(URLRequest(url: url))
            }
        }).disposed(by: viewModel.disposeBag)
        
        backButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.backButton.isHidden = true
            self?.webContentView.isHidden = true
        }).disposed(by: viewModel.disposeBag)
        
        shareButton.rx.tap.subscribe(onNext: { [weak self] in
            if let shareViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShareViewController") as? ShareViewController {
                shareViewController.linkTitle = self?.postEntity?.title
                shareViewController.linkUrl = self?.postEntity?.link
                shareViewController.modalPresentationStyle = .overCurrentContext
                shareViewController.sharedComplete = { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
                self?.present(shareViewController, animated: false, completion: nil)
            }
        }).disposed(by: viewModel.disposeBag)
    }
    
    func setupBinding() {
        bookmarkButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.bookmarkButton.isSelected = !self.bookmarkButton.isSelected
            self.viewModel.inputSavePost.onNext(self.bookmarkButton.isSelected)
        }).disposed(by: viewModel.disposeBag)
        
        viewModel.outputSavedPost.subscribe(onNext: { [weak self] in
            self?.bookmarkButton.isSelected = true
        }).disposed(by: viewModel.disposeBag)
    }
    
    func setupData() {
        if let postEntity = postEntity {
            authorLabel.text = postEntity.author
            titleLabel.text = postEntity.title
            timeLabel.text = postEntity.pubDate?.toStandardDateTimeFormat()
            postLabel.text = postEntity.desc
            
            let font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16.0)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4.0
            let attributes = [NSAttributedString.Key.font: font as Any, NSAttributedString.Key.paragraphStyle: paragraphStyle]
            let attrText = NSAttributedString(string: postEntity.desc ?? "", attributes: attributes)
            postLabel.attributedText = attrText
        }
        
        observer = webView.observe(\.estimatedProgress) { [weak self] (webView, change) in
            guard let `self` = self else { return }
            let progress = Float(webView.estimatedProgress)
            if self.progressView.progress < progress {
                self.progressView.setProgress(progress, animated: true)
            }
        }
        
        viewModel.inputCheckSavedPost.onNext(())
    }
    
    func openAnimation() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: { [weak self] in
                        self?.contentTopConstraint.constant = 0.0
                        self?.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
                        self?.view.layoutIfNeeded()
        },
                       completion: { (finish) in

        })
    }
    
    func closeAnimation() {
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: { [weak self] in
                        guard let `self` = self else { return }
                        self.contentTopConstraint.constant = self.contentView.bounds.height + self.view.safeAreaInsets.bottom
                        self.view.layoutIfNeeded()
                        self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            },
                       completion: { [weak self](finish) in
                        self?.dismiss(animated: false, completion: nil)
        })
    }
    
    // MARK: - Gesture
    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveLinear,
                       animations: { [weak self] in
                        guard let `self` = self else { return }
                        let translation = sender.translation(in: self.view)
                        self.contentTopConstraint.constant += translation.y
                        
                        if self.contentTopConstraint.constant < 0 {
                            self.contentTopConstraint.constant = 0
                        }
//                        self.contentView.center = CGPoint(x: self.contentView.center.x, y: self.contentView.center.y + translation.y)
                        sender.setTranslation(CGPoint.zero, in: self.view)
        },
                       completion: { (finish) in
                        
        })
        
        if sender.state == .ended {
            let translation = sender.translation(in: self.view)
            print("translation \(translation.y)")
            closeAnimation()
        }
    }
    
}

extension PostDetailViewController {
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
