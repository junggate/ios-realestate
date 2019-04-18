//
//  MyPostViewController.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 20/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import JGTabBarView
import RxSwift
import RxCocoa

class MyPostViewController: UIViewController, JGTabBar, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    open var tabTitle: String?
    open var noDataTitle: String?
    var viewModel: MyPostViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getData()
    }
    
    func setupUI() {
        collectionView.register(UINib(nibName: "NoDataCell", bundle: nil), forCellWithReuseIdentifier: "NoDataCell")
    }
    
    func setupBinding() {
        viewModel.postEntitiesSubject.subscribe(onNext: { [weak self] (posts) in
            self?.collectionView.reloadData()
        }).disposed(by: viewModel.disposeBag)
    }
    
    func setupData() {
    }

    func getTabTitle() -> String {
        return tabTitle ?? ""
    }
    
    func getViewController() -> UIViewController {
        return self
    }
    
    func onTouchTab() {
        
    }
    
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.getDataCount()
        if count == 0 {
            return 1
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let isNoData = viewModel.getDataCount() == 0
        
        var cell: UICollectionViewCell?
        if isNoData {
            if let noDataCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoDataCell", for: indexPath) as? NoDataCell {
                noDataCell.textLabel.text = noDataTitle
                cell = noDataCell
            }
        } else {
            let entities = try? viewModel.postEntitiesSubject.value()
            if let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostPreviousCell", for: indexPath) as? PostPreviousCell {
                if let entity = entities??[indexPath.row] {
                    postCell.setData(data: entity)
                }
                cell = postCell
            }
        }

        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostDetailViewController") as? PostDetailViewController {
            
            let entities = try? viewModel.postEntitiesSubject.value()
            if entities??.count ?? 0 > 0, let entity = entities??[indexPath.row] {
                detailController.postEntity = entity
            }
            
            detailController.modalPresentationStyle = .overCurrentContext
            present(detailController, animated: false, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isNoData = viewModel.getDataCount() == 0
        if isNoData {
            return collectionView.bounds.size
        } else {
            return CGSize(width: collectionView.bounds.width, height: 150)
        }
    }

}
