//
//  PostDateCell.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 01/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit

class PostDateCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    
    func setData(data: DateEntity) {
        dateLabel.text = data.date
        
        if data.date?.isEmpty ?? false {
            dateLabel.text = " - "
        }
    }
    
}
