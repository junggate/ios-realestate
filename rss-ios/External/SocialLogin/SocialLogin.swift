//
//  SocialLoginExternal.swift
//  realreview-iOS
//
//  Created by JungMoon-Mac on 2018. 4. 11..
//  Copyright © 2018년 JungMoon. All rights reserved.
//

import Foundation
import KakaoCommon
import KakaoOpenSDK
import FBSDKCoreKit
import FBSDKLoginKit
import NaverThirdPartyLogin

typealias SocialLoginResultClosure = ((_ success: Bool, _ error: String?) -> Void)
typealias SocialUpdateTokenResultClosure = ((_ token: String?) -> Void)
protocol SocialLogin: class {
    typealias LoginResultClosure = ((_ resultObject: SocialLoginResult?, _ error: Error?) -> Void)
    func socialLogin(resultClosure: @escaping LoginResultClosure)
    func updateToken(resultClosure: @escaping ((_ token: String?) -> Void))
    func removeToken()
}

final class KakaoLogin: SocialLogin {
    required init() {
        KOSession.shared()?.clientSecret = "fffb0d95f6f2d8e7290441736a55c7a9"
        KOSession.shared()?.isAutomaticPeriodicRefresh = true
    }
    
    func socialLogin(resultClosure: @escaping SocialLogin.LoginResultClosure) {

        guard let session = KOSession.shared() else {
            resultClosure(nil, NSError(domain: "KOSession is null.", code: -9000, userInfo: nil))
            return
        }
        
        if session.isOpen() {
            session.close()
        }
        
        session.open(completionHandler: { (error) -> Void in
            if session.isOpen() {
                KOSessionTask.userMeTask(completion: { (error, userMe) in
                    if let koUser = userMe {
                        let loginResult = SocialLoginResult()
                        loginResult.socialType = "kakao"
                        loginResult.id = koUser.id
                        loginResult.name = koUser.nickname
                        loginResult.profileImage = koUser.profileImageURL?.absoluteString
                        loginResult.email = koUser.account?.email
                        
                        func accessTokenTask() {
                            KOSessionTask.accessTokenInfoTask(completionHandler: { (accessTokenInfo, error) in
                                if let error = error as NSError? {
                                    switch error.code {
                                    case 5 : //KOErrorDeactivatedSession:
                                        // 세션이 만료된(access_token, refresh_token이 모두 만료된 경우) 상태
                                        break
                                    default:
                                        // 예기치 못한 에러. 서버 에러
                                        break
                                    }
                                } else { // 성공 (토큰이 유효함)
                                    loginResult.accessToken = session.token.accessToken
                                    print("남은 유효시간: \(session.token.accessTokenExpiresAt) (단위: ms)")
                                    print("loginResult \(loginResult)")
                                    resultClosure(loginResult, nil)
                                }
                            })
                        }
                        
                        if let account = koUser.account, account.email == nil && account.hasEmail == KOOptionalBoolean.true {
                            session.updateScopes(["account_email"], completionHandler: { (error) in
                                if let error = error {
                                    resultClosure(nil, error)
                                    return
                                }
                                
                                KOSessionTask.userMeTask(completion: { (error, userMe) in
                                    if let koUser = userMe {
                                        loginResult.email = koUser.account?.email
                                        accessTokenTask()
                                    }
                                })
                            })
                        } else {
                            accessTokenTask()
                        }
                    } else {
                        resultClosure(nil, error)
                    }
                })
                
            } else {
                resultClosure(nil, error)
            }
        })
    }
    
    func updateToken(resultClosure: @escaping ((String?) -> Void)) {
        let session: KOSession = KOSession.shared()
        session.refreshAccessToken { (error) in
            print("KakaoLogin expiresAccessTokenTime \(session.token.accessTokenExpiresAt)")
            if error == nil {
                resultClosure(session.token.refreshToken)
            } else {
                resultClosure(nil)
            }
            
        }
    }
    
    func removeToken() {
        let session: KOSession = KOSession.shared()
        session.close()
    }
}

final class FacebookLogin: SocialLogin {
    func socialLogin(resultClosure: @escaping SocialLogin.LoginResultClosure) {
        let appDelegate = UIApplication.shared.delegate
        let login = FBSDKLoginManager()
        var viewController = appDelegate!.window!?.rootViewController
        if viewController?.presentedViewController != nil {
            viewController = viewController!.presentedViewController!
        }
        login.logOut()
        print("FacebookLogin Request")
        login.logIn(withReadPermissions: ["public_profile", "email"], from: viewController, handler: { (result, error) in
            if error != nil {
                print("facebookRegister error \(error!)")
                resultClosure(nil, error)
            } else if result?.isCancelled ?? false {
            } else if let result = result { // Log-in
                let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, name, picture.type(large)"])
                graphRequest.start(completionHandler: { (connection, graphtResult, error) -> Void in
                    if error != nil {
                        print("Error: \(error!)")
                    } else if let fields = graphtResult as? [String: Any] {
                        let userId = fields["id"] as? String ?? ""
                        let email = fields["email"] as? String ?? ""
                        let name = fields["name"] as? String ?? "name"
                        let picture = fields["picture"] as? [String: Any]
                        let data = picture?["data"] as? [String: Any]
                        let profileImage = data?["url"] as? String ?? ""
                        
                        let loginResult = SocialLoginResult()
                        loginResult.id = userId
                        loginResult.email = email
                        loginResult.name = name
                        loginResult.profileImage = profileImage
                        loginResult.accessToken = result.token.tokenString
                        loginResult.socialType = "facebook"
                        print("loginResult \(loginResult)")
                        resultClosure(loginResult, nil)
                    }
                })
            }
            
        })
    }
    
    func updateToken(resultClosure: @escaping ((_ token: String?) -> Void)) {
        let current = FBSDKAccessToken.current() == nil ? nil : FBSDKAccessToken.current()
        resultClosure(current?.tokenString)
    }
    
    func removeToken() {
        let login = FBSDKLoginManager()
        login.logOut()
    }
}

final class NaverLogin: NSObject, SocialLogin, NaverThirdPartyLoginConnectionDelegate {
    let loginConnection = NaverThirdPartyLoginConnection.getSharedInstance()!
    var resultClosure: SocialLogin.LoginResultClosure?
    var updateTokenClosure:((_ token: String?) -> Void)?

    deinit {
        print("deinit \(self)")
    }

    func initialize() {
        loginConnection.delegate = self
        loginConnection.isInAppOauthEnable = true
        loginConnection.setOnlyPortraitSupportInIphone(true)
        loginConnection.serviceUrlScheme = "naverlogin-rssproject"
        loginConnection.consumerKey = "9VhHWGHmG4VxkFyNXOe_"
        loginConnection.consumerSecret = "nwtCjQcmZO"
        loginConnection.appName = "집합"
    }

    func socialLogin(resultClosure: @escaping SocialLogin.LoginResultClosure) {
        initialize()
        self.resultClosure = resultClosure

        if let accessTokenExpireDate = loginConnection.accessTokenExpireDate {
            print("NaverLogin accessTokenExpireDate \(accessTokenExpireDate)")
        }

        if loginConnection.accessToken == nil {
            loginConnection.requestThirdPartyLogin()
        } else if loginConnection.isValidAccessTokenExpireTimeNow() == false {
            loginConnection.requestAccessTokenWithRefreshToken()
        } else {
            requestUserInfo(accessToken: loginConnection.accessToken)
        }
    }

    func requestUserInfo(accessToken: String) {
        let apiUrl = "https://openapi.naver.com/v1/nid/me"
        let urlRequest = NSMutableURLRequest(url: URL(string: apiUrl)!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) { [unowned self](data, response, error) in
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        if let jsonResponse = json["response"] as? [String: String] {
                            
                            let loginResult = SocialLoginResult()
                            loginResult.id = jsonResponse["id"]
                            loginResult.name = jsonResponse["nickname"]
                            loginResult.email = jsonResponse["email"]
                            loginResult.accessToken = self.loginConnection.accessToken
                            loginResult.socialType = "naver"
                            loginResult.profileImage = jsonResponse["profile_image"]
                            print("loginResult \(loginResult)")
                            
                            DispatchQueue.main.async {
                                self.resultClosure?(loginResult, nil)
                            }
                        } else if let resultCode = json["resultcode"] as? String, let message = json["message"] as? String {
                            self.removeNaverToken()
                            DispatchQueue.main.async {
                                let error = NSError(domain: message, code: Int(resultCode) ?? 0, userInfo: nil)
                                self.resultClosure?(nil, error as Error)
                            }
                        }
                    }
                } catch {
                    
                }
                
            } else {
                DispatchQueue.main.async {
                    self.removeNaverToken()
                    self.resultClosure?(nil, error)
                }
            }
        }
        task.resume()
    }

    func removeToken() {
        self.loginConnection.requestDeleteToken()
        self.loginConnection.removeNaverLoginCookie()
    }

    func removeNaverToken() {
        DispatchQueue.main.async { [unowned self] in
            self.loginConnection.requestDeleteToken()
            self.loginConnection.removeNaverLoginCookie()
        }
    }

    func updateToken(resultClosure: @escaping ((_ token: String?) -> Void)) {
        initialize()
        let loginConnection = NaverThirdPartyLoginConnection.getSharedInstance()!
        if loginConnection.isValidAccessTokenExpireTimeNow() == false {
            updateTokenClosure = resultClosure
            loginConnection.requestAccessTokenWithRefreshToken()
        } else {
            resultClosure(loginConnection.accessToken)
        }
    }

    // MARK: - delegate
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFinishAuthorizationWithResult recieveType: THIRDPARTYLOGIN_RECEIVE_TYPE) {

    }

    // 로그인 성공
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        if let accessToken = loginConnection.accessToken {
            requestUserInfo(accessToken: accessToken)
        }
    }

    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        // 토큰 재발급
        if let accessToken = loginConnection.accessToken {
//            print("NaverLogin accessTokenExpireDate \(loginConnection.accessTokenExpireDate)")
            updateTokenClosure?(accessToken)
        }
    }

    func oauth20ConnectionDidFinishDeleteToken() {

    }

    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        self.resultClosure?(nil, error)
        self.updateTokenClosure?(nil)
    }

    func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {

    }
}

//final class GoogleLogin: NSObject, SocialLogin, GIDSignInDelegate, GIDSignInUIDelegate {
//    let googleButton = GIDSignInButton()
//    var loginResultClosure: LoginResultClosure?
//    func socialLogin(resultClosure: @escaping LoginResultClosure) {
//        GIDSignIn.sharedInstance()?.delegate = self
//        GIDSignIn.sharedInstance()?.uiDelegate = self
//
//        loginResultClosure = resultClosure
//
//        self.googleButton.sendActions(for: UIControl.Event.touchUpInside)
//    }
//
//    func updateToken(resultClosure: @escaping ((String?) -> Void)) {
//
//    }
//
//    func removeToken() {
//
//    }
//
//    // MARK: - GIDSignInDelegate
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if let error = error {
//            loginResultClosure?(nil, error)
//            return
//        }
//
//        let loginResult = SocialLoginResult()
//        loginResult.id = user.userID
//        loginResult.email = user.profile.email
//        loginResult.name = user.profile.name
//        loginResult.accessToken = user.authentication.accessToken
//        loginResult.socialType = "G"
//        print("loginResult \(loginResult)")
//        loginResultClosure?(loginResult, nil)
//    }
//
//    // MARK: - GIDSignInUIDelegate
//
//    // Stop the UIActivityIndicatorView animation that was started when the user
//    // pressed the Sign In button
//    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
//        if let error = error {
//            loginResultClosure?(nil, error)
//        }
//    }
//
//    // Present a view that prompts the user to sign in with Google
//    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
//        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
//            rootViewController.present(viewController, animated: true, completion: nil)
//
//        }
//    }
//
//    // Dismiss the "Sign in with Google" view
//    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
//        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
//            rootViewController.dismiss(animated: true, completion: ({
//
//            }))
//        }
//    }
//}
