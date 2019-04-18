//
//  BlogsUseCase.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 10/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BlogsUseCase: NSObject {
    let disposeBag = DisposeBag()
    
    private let blogsNetwork = GatewayBuilder.getBlogsNetwork()
    
    var blogsPageEntity: PageEntity?
    
    func blogs(next: Bool) -> Observable<(page: PageEntity?, entities: [BlogEntity]?)> {
        if next && !(blogsPageEntity?.hasNextPage ?? false) {
            return Observable<(page: PageEntity?, entities: [BlogEntity]?)>.create { (observer) -> Disposable in
                observer.onNext((self.blogsPageEntity, nil))
                return Disposables.create()
            }
        }
        
        if next == false {
            blogsPageEntity = nil
        }
        
        let observable = blogsNetwork.blogs(page: blogsPageEntity?.getNextPage() ?? 0)
        observable.subscribe(onNext: { [weak self] (result) in
            self?.blogsPageEntity = result.page
        }).disposed(by: disposeBag)
        return observable
    }
}
