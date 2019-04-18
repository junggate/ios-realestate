//
//  BlogViewController.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 07/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleMobileAds

class BlogViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
    let viewModel = BlogViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
        setupData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = CGSize(width: collectionView.bounds.size.width, height: 44.0)
    }
    
    func setupUI() {
        bannerView.adUnitID = "ca-app-pub-2432290974439865/9313315257"
        bannerView.rootViewController = self
//        bannerView.isAutoloadEnabled = true
        bannerView.load(GADRequest())
    }
    
    func setupBinding() {
        viewModel.blogEntitiesSubject.subscribe(onNext: { [weak self] (postEntities) in
            self?.collectionView.reloadData()
        }).disposed(by: viewModel.disposeBag)
    }
    
    func setupData() {
        viewModel.inputLoadData.onNext(())
    }
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getDataCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlogViewCell", for: indexPath)
        
        if let blogCell = cell as? BlogViewCell {
            let entities = try? viewModel.blogEntitiesSubject.value()
            blogCell.setData(data: entities?[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let entities = try? viewModel.blogEntitiesSubject.value()
        if let entity = entities?[indexPath.row] {
            if let webViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as? WebViewController {
                webViewController.title = entity.name
                webViewController.url = URL(string: entity.url ?? "")
                navigationController?.pushViewController(webViewController, animated: true)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewModel.getDataCount()-1 == indexPath.row {
            viewModel.inputNextData.onNext(())
        }
    }
}
