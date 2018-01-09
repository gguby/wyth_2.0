//
//  BSTError.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 27..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import UIKit

protocol BSTErrorProtocol: LocalizedError {
	var description: String { get }
    func cook(_ object: Any?)
}

extension BSTErrorProtocol {
    func cook(_ object: Any? = nil) {
        if let obj = object {
			logError("BSTERROR : \(self.description)", obj)
        } else {
			logError("BSTERROR : \(self.description)")
        }
    }
}

enum LoginError: Error, BSTErrorProtocol {
    case failed
    case failedCode(Int)
    
    var description: String {
        var desc = ""
        switch self {
        case .failed:
            desc = BSTFacade.localizable.error.loginFailed()
        case .failedCode(let code):
            desc = BSTFacade.localizable.error.loginFailedCode(code)
        default:
            break
        }
        return desc
    }
    
    func cook(_ object: Any? = nil) {
        switch self {
        case .failed:
            BSTFacade.ux.showAlert(self.description)
        case .failedCode(let code):
            if code == -1 {
                BSTFacade.ux.showAlert(self.description, {
//                    BSTFacade.ux.gotoIntro()
                })
            } else if code == 2 {
//                BSTFacade.ux.gotoIntro()
            }
        default:
            break
        }
    }
}

enum APIError: Int, Error, BSTErrorProtocol {
    
    case none = -1
//    case succeed = 200
//    case succeedOK
    
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case upgradeRequired = 426
    
    //server error
    case internalServerError = 500
    case notImplemented
    case badGateway
    case serviceUnavailable
    case gatewayTimeout
    
    case userExists = 901
    case userNotExists
    case sessionAleadyHasBeenDisconnected
    case invalidException
    case accessTokenCouldNotBeDecrypted
    case saveFailed
    
    var description: String {
        var desc = ""
        switch self {
        case .badRequest://400
            desc = BSTFacade.localizable.error.apiBadRequest()
        case .unauthorized:
            desc = BSTFacade.localizable.error.apiUnauthorized()
        case .forbidden:
            desc = BSTFacade.localizable.error.apiForbidden()
        case .notFound:
            desc = BSTFacade.localizable.error.apiNotFound()
        case .upgradeRequired:
            desc = BSTFacade.localizable.error.apiUpgradeRequired()
        case .internalServerError: //500
            desc = BSTFacade.localizable.error.apiInternalServerError()
        case .notImplemented:
            desc = BSTFacade.localizable.error.apiNotImplemented()
        case .badGateway:
            desc = BSTFacade.localizable.error.apiBadGateway()
        case .serviceUnavailable:
            desc = BSTFacade.localizable.error.apiServiceUnavailable()
        case .gatewayTimeout:
            desc = BSTFacade.localizable.error.apiGatewayTimeout()
        case .userExists: //901
            desc = BSTFacade.localizable.error.apiUserExists()
        case .userNotExists:
            desc = BSTFacade.localizable.error.apiUserNotExists()
        case .sessionAleadyHasBeenDisconnected:
            desc = BSTFacade.localizable.error.apiPaymentRequired()
        case .invalidException:
            desc = BSTFacade.localizable.error.apiInvalidException()
        case .accessTokenCouldNotBeDecrypted:
            desc = BSTFacade.localizable.error.apiAccessTokenCouldNotBeDecrypted()
        case .saveFailed:
            desc = BSTFacade.localizable.error.apiSaveFailed()
        default:
            break
        }
        return desc
    }
}

enum BSTError: Error, BSTErrorProtocol {
    case none
    case isEmpty
    case argumentError
    case nilError
	case unknown
	case typeDismatching
    case api(APIError)
    //    case api(code)
    //    case permission(PermissionErrorType)
    case device(DeviceError)
    case login(LoginError)
    
    var description: String {
        var description = ""
        switch self {
        case .isEmpty:
            description = BSTFacade.localizable.error.isEmpty()
        case .argumentError:
            description = BSTFacade.localizable.error.argumentError()
        case .nilError:
            description = BSTFacade.localizable.error.nilError()
        case .unknown:
            description = BSTFacade.localizable.error.unknown()
		case .typeDismatching:
			description = "type mismatching error"

        case .api(let error):
            description = error.description
        case .device(let error):
            description = error.description
        case .login(let error):
            description = error.description
        default:
            break
        }
        return description
    }
    
    func cookError(_ object: Any? = nil) {

        switch self {
        case .device(let error):
            error.cook(object)
        case .login(let error):
            error.cook(error)
//            BSTFacade.runInBackground {
//                error.cook(error)
//            }
//            fallthrough
        default:
            self.cook(object)
        }
    }
}
