//
//  PostViewCell.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 16/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import SDWebImage

class PostPreviousCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleRightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
    }
    
    func setData(data: PostEntity) {
        titleLabel.text = data.title ?? " - "
        descriptionLabel.attributedText = NSAttributedString(string: data.desc ?? " - ")
        if data.desc?.isEmpty ?? false {
            descriptionLabel.attributedText = NSAttributedString(string: " - ")
        }
        if let imgUrl = data.imgUrl, imgUrl.isEmpty == false {
            imageView.sd_setImage(with: URL(string: imgUrl), completed: nil)
            imageViewWidthConstraint.constant = 70
            titleRightConstraint.constant = 15
        } else {
            imageViewWidthConstraint.constant = 0
            titleRightConstraint.constant = 0
        }
        authorLabel.text = "\(data.author ?? " - ")"
        durationLabel.text = " \(data.pubDate?.toStandardDateTimeFormat() ?? " - ")"
    }
}
