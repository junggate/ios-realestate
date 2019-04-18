//
//  PostPreviousViewController.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 24/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import JGTabBarView

class PostPreviousViewController: UIViewController, JGTabBar, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerBgHeightConstraint: NSLayoutConstraint!
    
    open var headerHeight: CGFloat = 0.0
    open var tabBarHeight: CGFloat = 0.0
    
    let viewModel = PostPreviousViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
        setupData()
    }
    
    func setupUI() {
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        collectionView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: tabBarHeight, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: headerHeight, left: 0, bottom: tabBarHeight, right: 0)
        headerBgHeightConstraint.constant = headerHeight
    }
    
    func setupBinding() {
        viewModel.previousPostEntitiesSubject.subscribe(onNext: { [weak self] (postEntities) in
            self?.collectionView.reloadData()
        }).disposed(by: viewModel.disposeBag)
    }
    
    func setupData() {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getDataCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        let entities = try? viewModel.previousPostEntitiesSubject.value()
        if let postEntity = entities?[indexPath.row] as? PostEntity {
            let postPreviousCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostPreviousCell", for: indexPath) as? PostPreviousCell
            postPreviousCell?.setData(data: postEntity)
            cell = postPreviousCell
            
        } else if let dateEntity = entities?[indexPath.row] as? DateEntity {
            let postDateCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostDateCell", for: indexPath) as? PostDateCell
            postDateCell?.setData(data: dateEntity)
            cell = postDateCell
        } else if entities?[indexPath.row] as? AdEntity != nil {
            let admobCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdmobCell", for: indexPath) as? AdmobCell
            admobCell?.viewController = self
            cell = admobCell
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let entities = try? viewModel.previousPostEntitiesSubject.value()
        if let postEntity = entities?[indexPath.row] as? PostEntity {
            if let detailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostDetailViewController") as? PostDetailViewController {
                detailController.postEntity = postEntity
                viewModel.inputPostEntity.onNext(postEntity)
                detailController.modalPresentationStyle = .overCurrentContext
                present(detailController, animated: false, completion: nil)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let entities = try? viewModel.previousPostEntitiesSubject.value() else { return .zero }
        if entities.count == 0 {
            return .zero
        }
        
        if entities[indexPath.row] as? PostEntity != nil {
            return CGSize(width: collectionView.frame.size.width, height: 150)
        } else if entities[indexPath.row] as? DateEntity != nil {
            return CGSize(width: collectionView.frame.size.width, height: 20)
        } else if entities[indexPath.row] as? AdEntity != nil {
            return CGSize(width: collectionView.frame.size.width, height: 100)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewModel.getDataCount()-1 == indexPath.row {
            viewModel.inputLoadData.onNext(true)
        }
    }
    
    // JGTabBar
    func getTabTitle() -> String {
        return "지난글"
    }
    
    func getViewController() -> UIViewController {
        return self
    }
    
    func onTouchTab() {
        viewModel.inputLoadData.onNext(false)
    }
    
}
