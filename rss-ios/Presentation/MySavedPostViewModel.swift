//
//  MySavedPostViewModel.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 06/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit

class MySavedPostViewModel: MyPostViewModel {
    override func getData() {
        postEntitiesSubject.onNext(postUseCase.getSavedPost())
    }
}
