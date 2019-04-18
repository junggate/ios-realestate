//
//  AdmobCell.swift
//  rss-ios
//
//  Created by JungMoon-Mac on 18/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdmobCell: UICollectionViewCell, GADBannerViewDelegate {
    @IBOutlet weak var bannerView: GADBannerView!
    
    weak var viewController: UIViewController? {
        didSet {
            bannerView.rootViewController = viewController
            bannerView.isAutoloadEnabled = true
//            bannerView.load(GADRequest())
        }
    }

    override func awakeFromNib() {
        bannerView.adUnitID = "ca-app-pub-2432290974439865/9313315257"
        bannerView.delegate = self
    }

    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}
