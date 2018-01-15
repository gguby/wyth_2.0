//
//  SessionHandler.swift
//  BoostMINI
//
//  Created by Jack on 21/12/2017.
//  Copyright © 2017 IRIVER LIMITED. All rights reserved.

import Foundation
import Alamofire


class SessionHandler {

    static let shared = SessionHandler()
    //let baseURL = Definitions.api.base

	var cookie: String? 
	var token: String?
	
	var profile: BoostProfile?

	var pushToken: String = "test- TODO:"	// TODO:
	var osVersion: String = Float(UIDevice.current.systemVersion)

	
	var name: String? { return profile?.name }
	var email: String? { return profile?.email }
	
	
	// TODO : 로그인여부.
	var isLoginned: Bool {
		return !((token ?? "").isEmpty)
	}

	// TODO: 일단 UserDefaults. Realm 등등으로 바꾸려면 여기서.
	
	// TODO: Define쪽으로 빼려면 이것을
	fileprivate enum userPlistKey: String {
		case cookie		= "BSTuserCookie"
		case token		= "BSTuserToken"
		case profile	= "BSTuserProfile"
		case savedEmail	= "BSTuserSavedEmail"
	}
	
	private init() {
		
		
		#if DEBUG
			// for test
			let testCode = 2
			
			
			if testCode == 1 {
				// 가상 로그인 세팅
				UserDefaults.standard.set("0123456789abcdef", forKey: userPlistKey.token.rawValue)
				UserDefaults.standard.synchronize()
			}
			if testCode == 2 {
				// 강제 로그아웃 세팅
				UserDefaults.standard.removeObject(forKey: userPlistKey.token.rawValue)
				UserDefaults.standard.synchronize()
			}
			
		#endif
		
		
		// TODO: 암호화 필요?
		// TODO: 스트링 define으로 뺴려면 고고
		self.cookie = UserDefaults.standard.string(forKey: userPlistKey.cookie.rawValue)
		self.token = UserDefaults.standard.string(forKey: userPlistKey.token.rawValue)
		self.profile = UserDefaults.standard.object(forKey: userPlistKey.profile.rawValue) as? BoostProfile

	}

	
	func setSession(_ token: String, _ data: AccountsPostResponse?) {
		setSession(token, data == nil ? nil : BoostProfile.from(data!))
	}
	
	func setSession(_ token: String, _ data: BoostProfile?) {
		guard let info = data else {
			// logout ?
			self.logout()
			return
		}
		self.login(token: token, profile: info)
	}
	
	func logout() {
		self.cookie = nil
		self.token = nil
		self.profile = nil

		UserDefaults.standard.removeObject(forKey: userPlistKey.cookie.rawValue)
		UserDefaults.standard.removeObject(forKey: userPlistKey.token.rawValue)
		UserDefaults.standard.removeObject(forKey: userPlistKey.profile.rawValue)

		UserDefaults.standard.synchronize()
	}

	func login(token: String, profile: BoostProfile) {
		self.cookie = ""
		self.token = token
		self.profile = profile
		
		UserDefaults.standard.set(self.cookie, forKey: userPlistKey.cookie.rawValue)
		UserDefaults.standard.set(self.token, forKey: userPlistKey.token.rawValue)
		UserDefaults.standard.set(self.profile, forKey: userPlistKey.profile.rawValue)

		UserDefaults.standard.synchronize()
	}

	
	var savedEmail: String? {
		get {
			let savedEmail = UserDefaults.standard.string(forKey: userPlistKey.savedEmail.rawValue)
			if let em = savedEmail, !em.isEmpty {
				return em
			}
			return nil
		}
		set {
			UserDefaults.standard.set(newValue, forKey: userPlistKey.savedEmail.rawValue)
			UserDefaults.standard.synchronize()
		}
	}

	
	
	
	
//
//    var accountList: Array<Account> = []
//
//    var isFirstLogin = false
//
//    func getHeader() -> HTTPHeaders {
//        return Definitions.api.baseHeader
//    }
//
//    var needSignUpToken: String?
//    var needSignUpSecret: String?
//    var needSignUpService: ServiceType?
//
//    var deviceToken: String?
//
//    func login(accessToken: String, accessTokenSecret: String, service: ServiceType, callBack: LoginViewController) {
//        print(accessToken)
//
//        let parameters: Parameters = [
//            "accessToken": accessToken,
//            "accessTokenSecret": accessTokenSecret,
//            "socialType": service.name(),
//        ]
//
//        let uri = baseURL + "accounts/signin"
//
//        Alamofire.request(uri, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: getHeader()).responseJSON(completionHandler: {
//            response in
//
//            switch response.result {
//            case let .success(json):
//
//                if let code: HTTPCode = HTTPCode(rawValue: (response.response?.statusCode)!) {
//                    switch code {
//
//                    case .SUCCESS :
//
//                        var cookie: String?
//
//                        if callBack.isAddAccount == false {
//                            cookie = self.saveCookies(response: response)
//                            self.cookie = cookie
//                        } else {
//                            cookie = self.addCookie(response: response)
//                            self.loadCookies()
//                        }
//
//                        let jsonData = json as! NSDictionary
//
//                        let idNum = jsonData["id"] as! NSNumber
//                        let idStr = idNum.stringValue
//
//                        let account = Account(properties: [
//                            "userId": idStr,
//                            "email": jsonData["email"] as! String,
//                            "accessToken": accessToken,
//                            "sessionToken": cookie!,
//                            "nickName": jsonData["nickName"] as! String,
//                            "service": service.name(),
//                        ])
//
//                        self.addAccount(account: account)
//
//                        self.refreshAPNSToken()
//
//                        callBack.loginSuccess()
//
//                    case .USERNOTEXIST :
//
//                        callBack.goAgreement()
//
//                        self.needSignUpToken = accessToken
//                        self.needSignUpSecret = accessTokenSecret
//                        self.needSignUpService = service
//
//                        break
//                    case .UNAUTORIZED :
//                        break
//                    }
//                }
//
//                print((response.response?.statusCode)!)
//                print(json)
//            case let .failure(error):
//                print(error)
//            }
//        })
//    }
//
//    func logoutAll() {
//        let uri = baseURL + "accounts/signout"
//
//        Alamofire.request(uri, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: getHeader()).responseString(completionHandler: {
//            response in
//
//            switch response.result {
//            case let .success(json):
//
//                print("logout: \(json)")
//                GIDSignIn.sharedInstance().signOut()
//
//                self.clearCookies()
//                self.clearAccountAll()
//                self.goLoginView()
//
//            case let .failure(error):
//                print(error)
//            }
//        })
//    }
//
//    func signout(completionHandler _: @escaping () -> Void) {
//        let uri = baseURL + "accounts/signout"
//
//        Alamofire.request(uri, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: getHeader()).responseString(completionHandler: {
//            response in
//
//            switch response.result {
//            case let .success(json):
//
//                let account = self.getCurrentAccount()
//
//                if account?.service == "GOOGLE" {
//                    GIDSignIn.sharedInstance().signOut()
//                }
//
//                if account?.service == "FACEBOOK" {
//                    // facebook error code 304
//                    FBSDKSessionHandler().logOut()
//                }
//
//                if account?.service == "TWITTER" {
//                    Twitter.sharedInstance().sessionStore.logOutUserID((account?.accessToken)!)
//                }
//
//                UserDefaults.standard.removeObject(forKey: self.cookie!)
//
//                self.clearCookies()
//
//                self.removeAccount(userId: (account?.userId)!)
//
//                self.goLoginView()
//
//                print((response.response?.statusCode)!)
//                print(json)
//            case let .failure(error):
//                print(error)
//            }
//        })
//    }
//
//    func signUp(homePageURL: String, nickName: String, selfIntro: String, profile: UIImage, completionHandler: @escaping () -> Void) {
//        guard let token = self.deviceToken else {
//            print("not Token")
//            return
//        }
//
//        let parameters: Parameters = [
//            "nickName": nickName,
//            "socialType": self.needSignUpService!.name(),
//            "accessToken": self.needSignUpToken!,
//            "accessTokenSecret": self.needSignUpSecret!,
//            "selfIntro": selfIntro,
//            "homePageUrl": homePageURL,
//            "deviceType": Definitions.api.AppDevice.uppercased(),
//            "pushToken": token,
//        ]
//
//        let uri = baseURL + "accounts/signup"
//        let fileName = "\(nickName).jpg"
//
//        Alamofire.upload(multipartFormData: { multipartFormData in
//            if let imageData = UIImageJPEGRepresentation(profile, 1) {
//                multipartFormData.append(imageData, withName: "file", fileName: fileName, mimeType: "image/jpeg")
//            }
//        }, usingThreshold: UInt64(), to: URL(string: uri, parameters: parameters as! [String: String])!, method: .post, headers: getHeader(), encodingCompletion: {
//            encodingResult in
//            switch encodingResult {
//            case let .success(upload, _, _):
//
//                upload.uploadProgress(closure: { _ in
//
//                })
//
//                upload.responseJSON { response in
//                    // print response.result
//                    if (response.response?.statusCode) != 200 { return }
//
//                    switch response.result {
//                    case let .success(json):
//
//                        self.cookie = self.saveCookies(response: response)
//
//                        let jsonData = json as! NSDictionary
//
//                        let idNum = jsonData["iZZZZZd"] as! NSNumber
//                        let idStr = idNum.stringValue
//
//                        let account = Account(properties: [
//                            "userId": idStr,
//                            "email": jsonData["email"] as! String,
//                            "accessToken": self.needSignUpToken!,
//                            "sessionToken": self.cookie!,
//                            "nickName": jsonData["nickName"] as! String,
//                            "service": jsonData["socialType"] as! String,
//                        ])
//
//                        self.addAccount(account: account)
//
//                        completionHandler()
//                    case let .failure(error):
//                        print(error)
//                    }
//                }
//
//            case let .failure(encodingError):
//                print(encodingError.localizedDescription)
//            }
//        })
//    }
//
//    func withDraw() {
//        let uri = baseURL + "accounts/withdraw"
//
//        Alamofire.request(uri, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: getHeader()).responseString(completionHandler: {
//            response in switch response.result {
//            case let .success(json):
//                print((response.response?.statusCode)!)
//                print(json)
//            case let .failure(error):
//                print(error)
//            }
//        })
//    }
//
//    func checkNickname(nickname: String, completionHandler: @escaping (DataResponse<String>) -> Void) {
//        let uri = baseURL + "accounts/nickname"
//        let parameters: Parameters = [
//            "nickName": nickname,
//        ]
//
//        Alamofire.request(uri, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: getHeader()).responseString(completionHandler: completionHandler)
//    }
//
//    func refreshAPNSToken() {
//        if let token = self.deviceToken {
//            let uri = baseURL + "users/refreshToken"
//
//            let parameters: Parameters = [
//                "token": token,
//            ]
//
//            Alamofire.request(uri, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: getHeader()).responseString(completionHandler: {
//                response in switch response.result {
//                case let .success(json):
//                    print((response.response?.statusCode)!)
//                    print(json)
//                case let .failure(error):
//                    print(error)
//                }
//            })
//        }
//    }
//}
//
//enum ServiceType: String {
//    case Google = "GOOGLE", Twitter = "TWITTER", FaceBook = "FACEBOOK", SM = "SMTOWN"
//
//    func name() -> String {
//        switch self {
//        case .Google:
//            return "GOOGLE"
//        case .Twitter:
//            return "TWITTER"
//        case .FaceBook:
//            return "FACEBOOK"
//        case .SM:
//            return "SMTOWN"
//        }
//    }
//}
//
//enum HTTPCode: Int {
//    case SUCCESS = 200
//    case UNAUTORIZED = 401
//    case USERNOTEXIST = 901
//}
//
//extension SessionHandler {
//
//    func checkPush(viewConroller: UIViewController) {
//
//        let isCheckPush: Bool = UserDefaults.standard.bool(forKey: "pushNotification")
//
//        if isCheckPush == false {
//
//            let msg = "이벤트 및 프로모션 알림을 받으시겠습니까?"
//
//            let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "동의", style: UIAlertActionStyle.default, handler: { (_: UIAlertAction!) in
//
//                UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
//                UIApplication.shared.registerForRemoteNotifications()
//
//                UserDefaults.standard.set(true, forKey: "pushNotification")
//            }))
//
//            alert.addAction(UIAlertAction(title: "동의 안함", style: UIAlertActionStyle.cancel, handler: nil))
//            viewConroller.present(alert, animated: true, completion: nil)
//        }
//    }
//
//    func goLoginView() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.goLogin()
//    }
//
//    func checkLogout(statusCode: Int) {
//        if statusCode == HTTPCode.UNAUTORIZED.rawValue {
//            goLoginView()
//        }
//    }
//}
//
//extension SessionHandler {
//
//    func changeCookie(account: Account) {
//
//        let properties = account.cookieProperties
//        if let cookie = HTTPCookie(properties: properties as! [HTTPCookiePropertyKey: Any]) {
//            self.cookie = cookie.value
//            print("Change Cookie: \(cookie.value)")
//            HTTPCookieStorage.shared.setCookie(cookie)
//
//            var cookieArray = [[HTTPCookiePropertyKey: Any]]()
//
//            cookieArray.append(properties as! [HTTPCookiePropertyKey: Any])
//
//            UserDefaults.standard.set(cookieArray, forKey: "currentCookie")
//            UserDefaults.standard.synchronize()
//
//            refreshAPNSToken()
//        }
//    }
//
//    func addCookie(response: DataResponse<Any>) -> String? {
//        let headerFields = response.response?.allHeaderFields as! [String: String]
//        let url = response.response?.url
//        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url!)
//
//        var cookiesString: String?
//
//        if cookies.count == 0 {
//            return cookiesString
//        }
//
//        for cookie in cookies {
//            cookiesString = cookie.value
//            print("Add Cookie: \(cookie.value)")
//
//            UserDefaults.standard.set(cookie.properties!, forKey: cookiesString!)
//        }
//
//        return cookiesString
//    }
//
//    func saveCookies(response: DataResponse<Any>) -> String? {
//        var cookieArray = [[HTTPCookiePropertyKey: Any]]()
//
//        let cookiesString: String? = addCookie(response: response)
//
//        let cookieProperty = UserDefaults.standard.object(forKey: cookiesString!)
//
//        cookieArray.append(cookieProperty as! [HTTPCookiePropertyKey: Any])
//
//        UserDefaults.standard.set(cookieArray, forKey: "currentCookie")
//        UserDefaults.standard.synchronize()
//
//        return cookiesString
//    }
//
//    func clearCookies() {
//        if let cookies = HTTPCookieStorage.shared.cookies {
//            for cookie in cookies {
//                HTTPCookieStorage.shared.deleteCookie(cookie)
//            }
//        }
//
//        UserDefaults.standard.removeObject(forKey: "currentCookie")
//        UserDefaults.standard.synchronize()
//    }
//
//    func isExistCookie() -> Bool {
//        if cookie == nil {
//            return false
//        }
//
//        return true
//    }
//
//    func loadCookies() {
//        print("--------------------------------------------------")
//        print(UserDefaults.standard.object(forKey: "currentCookie"))
//        print("--------------------------------------------------")
//        guard let cookieArray = UserDefaults.standard.array(forKey: "currentCookie") as? [[HTTPCookiePropertyKey: Any]] else { return }
//        for cookieProperties in cookieArray {
//            if let cookie = HTTPCookie(properties: cookieProperties) {
//
//                self.cookie = cookie.value
//                print("Load Cookie: \(cookie.value)")
//                HTTPCookieStorage.shared.setCookie(cookie)
//            }
//        }
//    }
//
//    func getCookieHeader() -> [String: String]? {
//
//        if let cookies = HTTPCookieStorage.shared.cookies {
//            for cookie in cookies {
//                return HTTPCookie.requestHeaderFields(with: [cookie])
//            }
//        }
//
//        return nil
//    }
//}
//
//class Account {
//
//    var email: String?
//    var accessToken: String?
//    var sessionToken: String?
//    var service: String?
//    var userId: String?
//    var nickName: String?
//
//    var imagePath: String?
//
//    public init(properties: [String: Any]) {
//        email = properties["email"] as? String
//        accessToken = properties["accessToken"] as? String
//        sessionToken = properties["sessionToken"] as? String
//        service = properties["service"] as? String
//        userId = properties["userId"] as? String
//        nickName = properties["nickName"] as? String
//    }
//
//    func removeProfile() {
//        UserDefaults.standard.removeObject(forKey: userId!)
//    }
//
//    open var cookieProperties: Any? {
//        return UserDefaults.standard.object(forKey: self.sessionToken!)
//    }
//
//    open var properties: [String: String] {
//        var imagePath = ""
//
//        if self.imagePath != nil {
//            imagePath = self.imagePath!
//        } else {
//            imagePath = ""
//        }
//
//        return [
//            "email": self.email!,
//            "accessToken": self.accessToken!,
//            "sessionToken": self.sessionToken!,
//            "service": self.service!,
//            "userId": self.userId!,
//            "nickName": self.nickName!,
//            "imagePath": imagePath,
//        ]
//    }
//
//    open var logoImage: UIImage {
//        let serviceType: ServiceType = ServiceType(rawValue: service!)!
//
//        switch serviceType {
//        case .Google:
//            return UIImage(named: "logo_gg_02")!
//        case .FaceBook:
//            return UIImage(named: "logo_fb_02_on")!
//        case .Twitter:
//            return UIImage(named: "logo_tw_02_on")!
//        case .SM :
//            return UIImage(named: "logo_sm_02_on")!
//        }
//    }
//}
//
//extension UserDefaults {
//    func set(image: UIImage?, forKey key: String) {
//        guard let image = image else {
//            set(nil, forKey: key)
//            return
//        }
//        set(UIImageJPEGRepresentation(image, 1.0), forKey: key)
//    }
//
//    func image(forKey key: String) -> UIImage? {
//        guard let data = data(forKey: key), let image = UIImage(data: data)
//        else { return nil }
//        return image
//    }
//}
//
//extension SessionHandler {
//
//    open func loadAccountList() {
//        guard let accountArray = UserDefaults.standard.array(forKey: "accountList") as? [[String: Any]] else { return }
//
//        print(accountArray)
//
//        accountList.removeAll()
//
//        for account in accountArray {
//            let account: Account = Account(properties: account)
//            accountList.append(account)
//        }
//    }
//
//    func saveProfileImage(image: UIImage, userId: String) {
//        let imgData = UIImageJPEGRepresentation(image, 1)
//        UserDefaults.standard.set(imgData, forKey: userId)
//    }
//
//    func loadProfile(userId _: String) {
//    }
//
//    func syncAccount() {
//        var accountArray = [[String: Any]]()
//        for account in accountList {
//            print("Sync Account :-----------------------------------------------------")
//            print("Sync Account NickName:" + account.nickName!)
//            print("Sync Account UserId:" + account.userId!)
//            print("Sync Account Session Token :" + account.sessionToken!)
//            print("Sync Account Access Token :" + account.accessToken!)
//            print("Sync Account :-----------------------------------------------------")
//            accountArray.append(account.properties)
//        }
//
//        UserDefaults.standard.set(accountArray, forKey: "accountList")
//        UserDefaults.standard.synchronize()
//    }
//
//    func replaceAccount(account: Account) {
//
//        let index = accountList.index(where: { $0.userId == account.userId })
//        if let index = index {
//            accountList[index] = account
//            syncAccount()
//        }
//    }
//
//    func addAccount(account: Account) {
//
//        let index = accountList.index(where: { $0.userId == account.userId })
//        if let index = index {
//            accountList[index] = account
//        } else {
//            accountList.append(account)
//        }
//
//        syncAccount()
//    }
//
//    func getCurrentAccount() -> Account? {
//        for account in accountList {
//            if cookie == account.sessionToken {
//                return account
//            }
//        }
//        return nil
//    }
//
//    func clearAccountAll() {
//
//        for account in accountList {
//            UserDefaults.standard.removeObject(forKey: account.userId!)
//            UserDefaults.standard.removeObject(forKey: account.sessionToken!)
//        }
//
//        accountList.removeAll()
//        UserDefaults.standard.removeObject(forKey: "accountList")
//        UserDefaults.standard.synchronize()
//    }
//
//    func removeAccount(userId: String) {
//        print(accountList)
//
//        let filteredArray = accountList.filter {
//            (account) -> Bool in
//            userId != account.userId
//        }
//
//        accountList = filteredArray
//        syncAccount()
//    }
//a
//    func includeNotCurrentUser() -> Array<Account> {
//        let accountList = SessionHandler.shared.accountList.filter({
//            (account) -> Bool in
//            self.getCurrentAccount()?.userId != account.userId
//        })
//
//        return accountList
//    }
//
//    func isMyProfile(id: Int) -> Bool {
//        let myAccount = getCurrentAccount()
//
//        let userId = Int((myAccount?.userId)!)
//
//        if userId == id {
//            return true
//        }
//
//        return false
//    }
	
	
}
