//
//  TodayPostViewCell.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 22/12/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import SDWebImage

class PostTodayCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    func setData(data: PostEntity?, index: Int) {
        titleLabel.text = data?.author
        descriptionLabel.attributedText = NSAttributedString(string: data?.title ?? " - ")
        durationLabel.text = " \(data?.pubDate?.toDate()?.offsetString() ?? " - ")"
        if let imgUrl = data?.imgUrl, imgUrl.isEmpty == false {
            imageView.sd_setImage(with: URL(string: imgUrl), completed: nil)
        } else {
            imageView.image = UIImage(named: "bg\(index)")
        }
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let standardHeight = UltravisualLayoutConstants.Cell.standardHeight
        let featuredHeight = UltravisualLayoutConstants.Cell.featuredHeight
        
        let delta = (featuredHeight - frame.height) / (featuredHeight - standardHeight)
        
        let minAlpha: CGFloat = 0.3
        let maxAlpha: CGFloat = 0.5
        imageView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
        
        titleLabel.alpha = 1.0 - (delta * (1.0 - 0.1))
        durationLabel.alpha = 1.0 - (delta * (1.0 - 0.1))
        
        let scale = 1.0 - (delta * (1.0 - 0.76)) // Font size 20.0 to 26.0
        descriptionLabel.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
    }
    
}
