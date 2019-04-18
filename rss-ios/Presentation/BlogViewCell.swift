//
//  BlogViewCell.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 20/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import SDWebImage

class BlogViewCell: UICollectionViewCell {
    
    @IBOutlet weak var blogImageView: UIImageView!
    @IBOutlet weak var blogNameLabel: UILabel!
 
    var data: BlogEntity?
    
    override func awakeFromNib() {
    }
        
    func setData(data: BlogEntity?) {
        self.data = data
        blogImageView?.image = nil
        if let imgUrl = data?.imgUrl {
            blogImageView?.sd_setImage(with: URL(string: imgUrl), completed: { (image, error, type, url) in
                
            })
        }
        blogNameLabel.text = data?.name
    }
}
