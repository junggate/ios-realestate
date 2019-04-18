//
//  SocialShare.swift
//  realreview-iOS
//
//  Created by JungMoon-Mac on 2018. 5. 29..
//  Copyright © 2018년 JungMoon. All rights reserved.
//

import UIKit
import KakaoMessageTemplate
import KakaoCommon
import KakaoLink
import FBSDKShareKit

let kContentText = "'집합' 공유 글 보기"

protocol SocialShare: class {
    func share(title: String, imageUrl: String, linkUrl: String)
    func canOpenApp() -> Bool?
}

class SocialShareKakaoTalk: SocialShare {
    func share(title: String, imageUrl: String, linkUrl: String) {
        let template = KMTFeedTemplate { (feedTemplateBuilder) in
            feedTemplateBuilder.content = KMTContentObject(builderBlock: { (contentBuilder) in
                contentBuilder.title = title
                contentBuilder.desc = kContentText
                if let imageUrl = URL(string: imageUrl) {
                    contentBuilder.imageURL = imageUrl
                }
                contentBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.webURL = URL(string: linkUrl)
                    linkBuilder.mobileWebURL = URL(string: linkUrl)
                })
            })
            
            feedTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                buttonBuilder.title = "바로 확인하기"
                buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.webURL = URL(string: linkUrl)
                    linkBuilder.mobileWebURL = URL(string: linkUrl)
                })
            }))
        }
        
        KLKTalkLinkCenter.shared().sendDefault(with: template,
                                               success: { (warningMessage, argumentMessage) in
                                                
        },
                                               failure: { (error) in
                                                print("error \(error)")
        })
    }
    
    func canOpenApp() -> Bool? {
        return UIApplication.shared.canOpenURL(URL(string: "kakaolink://")!)
    }
}

enum ScrapType: String {
    case website
    case video
    case music
    case book
    case article
    case profile
}

struct ScrapInfo {
    var title: String!
    var desc: String!
    var imageUrls: [String]!
    var type: ScrapType!
    
    func toJsonString() -> String! {
        var dictionary = [String: AnyObject]()
        
        if title != nil {
            dictionary["title"] = title as AnyObject?
        }
        
        if desc != nil {
            dictionary["desc"] = desc as AnyObject?
        }
        
        if let imageUrls = imageUrls, imageUrls.count > 0 {
            dictionary["imageurl"] = imageUrls as AnyObject?
        }
        
        if type != nil {
            dictionary["type"] = type.rawValue as AnyObject?
        }
        
        if dictionary.count == 0 {
            return nil
        }
        
        return SocialShareKakaoStory.convertJsonString(dictionary as AnyObject)
    }
}

class SocialShareKakaoStory: SocialShare {
    let storyLinkURLBaseString = "storylink://posting"
    
    func canOpenApp() -> Bool? {
        return UIApplication.shared.canOpenURL(URL(string: "storylink://")!)
    }
    
    func share(title: String, imageUrl: String, linkUrl: String) {
        
        var scrapInfo = ScrapInfo()
        scrapInfo.title = kContentText
        scrapInfo.desc = title
        scrapInfo.imageUrls = [imageUrl]
        scrapInfo.type = ScrapType.website
        
//        let urlString = makeStoryLink("\(kContentText)\n\(title)\n\(linkUrl)",
//            appBundleId: "com.zuminternet.ios.realreview",
//            appVersion: "1.0",
//            appName: "핏뷰",
//            scrapInfo: scrapInfo)!
//        let url = URL(string: urlString)
//        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    func makeStoryLink(_ postingText: String, appBundleId: String, appVersion: String, appName: String, scrapInfo: ScrapInfo!) -> String! {
        var parameters: [String: String] = [String: String]()
        parameters["post"] = postingText
        parameters["apiver"] = "1.0"
        parameters["appid"] = appBundleId
        parameters["appver"] = appVersion
        parameters["appname"] = appName
        
        if let scrapInfo = scrapInfo, let infoString = scrapInfo.toJsonString() {
            parameters["urlinfo"] = infoString
        }
        
        let parameterString = self.HTTPArgumentsStringForParameters(parameters)
        return "\(storyLinkURLBaseString)?\(parameterString ?? "")"
    }
    
    func canOpenStoryLink() -> Bool {
        if let url = URL(string: storyLinkURLBaseString) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    func HTTPArgumentsStringForParameters(_ parameters: [String: String]) -> String! {
        let arguments: NSMutableArray = NSMutableArray(capacity: parameters.count)
        
        for (key, value) in parameters {
            arguments.add("\(key)=\(encodedURLString(value))")
        }
        
        return arguments.componentsJoined(by: "&")
    }
    
    func encodedURLString(_ string: String) -> String {
        //let customAllowedSet =  CharacterSet(charactersIn: ":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`").inverted
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    static func convertJsonString(_ object: AnyObject) -> String! {
        if let jsonData: Data = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            if let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                return String(jsonString)
            }
        }
        
        return nil
    }
}

class SocialShareFacebook: SocialShare {
    func share(title: String, imageUrl: String, linkUrl: String) {
        let linkContent = FBSDKShareLinkContent()
        linkContent.contentURL = URL(string: linkUrl)!
        
        let appDelete = UIApplication.shared.delegate
        guard let viewController = appDelete?.window??.rootViewController else { return }
        if let viewController = viewController.presentedViewController {
            FBSDKShareDialog.show(from: viewController, with: linkContent, delegate: nil)
        } else {
            FBSDKShareDialog.show(from: viewController, with: linkContent, delegate: nil)
        }
    }
    
    func canOpenApp() -> Bool? {
        return nil
    }
}

class SocialShareLine: SocialShare {
    func share(title: String, imageUrl: String, linkUrl: String) {
        var urlString = "line://msg/text/?\(linkUrl)"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url = URL(string: urlString)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    func canOpenApp() -> Bool? {
        return UIApplication.shared.canOpenURL(URL(string: "line://")!)
    }
}
