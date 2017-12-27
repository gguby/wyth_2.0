//
//  LoginModel.swift
//  BoostMINI
//
//  Created by HS Lee on 27/12/2017.
//  Copyright © 2017 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit

//enum APIError: Error {
//    case 404:
//    case 400:
//}
//
//enum BSTError: Error {
//    case login(LoginCode)
//    case api(code)
//
//    func action() {
//        switch self {
//        case .login(error):
//            //action
//        case .api(code):
//            ExceptionHandler.alert
//
//        default:
//            //
//        }
//    }
//
//    func alertActioln() {
//        BSTUXHanlder.showAlert(message: self.message)
//    }
//}

class LoginModel {
    
    //MARK: * properties --------------------
    var userId: String?
    var userName: String?

    //MARK: * IBOutlets --------------------


    //MARK: * Initialize --------------------

    init() {

    }


    //MARK: * Main Logic --------------------
    class func getUser() -> LoginModel? {
        //api call'
        //moya(alamofire) -> data

        do {

			
		} catch let error as BSTError {
			error.action()
		}

        return nil
    }

    class func register() {
        //moya(alamofire) -> data
    }
}

//class LoginBizLogic {
//    func getUser() -> LoginModel? {
//        //api call
//        return nil
//    }
//
//    func getUser() -> LoginModel? {
//        //api call
//        return nil
//    }
//}

class LoginViewModel {//presentation
    
//    func getUserInfo {
//        let login = LoginBizLogic.getUser()
//        login.userName = "fldjafldsajfldsja"
//    }
//
//    func usedNameForLocal() {
//        return "user" + "lllll"
//    }
}


