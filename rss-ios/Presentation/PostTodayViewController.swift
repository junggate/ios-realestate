//
//  PostTodayViewController.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 24/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import JGTabBarView

class PostTodayViewController: UIViewController, JGTabBar, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = PostTodayViewModel()
    let randomIndex = Int.random(in: 1...5)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
        setupData()
    }
    
    func setupUI() {
        collectionView.collectionViewLayout = UltravisualLayout()
    }
    
    func setupBinding() {
        viewModel.todayPostEntitiesSubject.subscribe(onNext: { [weak self] (postEntities) in
            self?.collectionView.reloadData()
        }).disposed(by: viewModel.disposeBag)
        
    }
    
    func setupData() {
        viewModel.inputLoadData.onNext(false)
    }
    
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getDataCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostTodayCell", for: indexPath)
        if let todayPostViewCell = cell as? PostTodayCell {
            let entities = try? viewModel.todayPostEntitiesSubject.value()
            todayPostViewCell.setData(data: entities?[indexPath.row], index: (randomIndex+indexPath.row)%5+1)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostDetailViewController") as? PostDetailViewController {
            
            let entities = try? viewModel.todayPostEntitiesSubject.value()
            if let postEntity = entities?[indexPath.row] {
                detailController.postEntity = postEntity
                viewModel.inputPostEntity.onNext(postEntity)
            }
            detailController.modalPresentationStyle = .overCurrentContext
            present(detailController, animated: false, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewModel.getDataCount()-1 == indexPath.row {
            viewModel.inputLoadData.onNext(true)
        }
    }
    
    // JGTabBar
    func getTabTitle() -> String {
        return "투데이"
    }
    
    func getViewController() -> UIViewController {
        return self
    }
    
    func onTouchTab() {
        
    }
}
