//
//  BSTError.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 27..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import Foundation
import Alamofire

protocol BSTErrorProtocol: LocalizedError {
	/// 해당 오류에 대한 사용자 메시지(alert, toast) 또는 Console 출력용
	var description: String { get }
	
	/// 에러 캐치 이후, 액션 처리를 위한 함수
	///
	/// - Parameter object: 에러 처리 시 넘겨받기 위한 object
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


/// 에러는 아닌데 뭔가 처리해야겠고 하는 그런 케이스에 사용한다.
/// 지금의 restAPI는 statuscode를 봐야하는 케이스가 있다. 하지만 generated된 코드에서는 body만을 반환한다... 그런 시나리오에서 사용할 수 있다.
/// BSTErrorTester.checkWhiteCode(error) 가 nil이 아니면, whiteError에 해당한다. (isFailure에서는 잡히지 않는다)
/// 이 경우, 오류는 아니지만 특수 케이스에 대한 처리를 해줘야 한다. ( WhiteError.code 로 Response의 statusCode를 직접 받을 수 있다. )
enum WhiteError: Error, BSTErrorProtocol {
	case statusCode(Int)
	case codeWithMessage(Int, String)
	
	// 암세포가 자라나고 있어요~
	var description: String {
		switch self {
		case .statusCode(let code):
			return BSTFacade.localizable.error.statusCode(code)
		case .codeWithMessage(let code, let message):
			return BSTFacade.localizable.error.statusCoddWithMessage(code, message)
		}
	}
	
	
	
	func cook(_ object: Any? = nil) {
		// do nothing
	}
	
	var code: Int? {
		switch self {
		case .statusCode(let code):
			return code
		case .codeWithMessage(let code, _):
			return code
		}
	}
	
	var message: String? {
		switch self {
		case .statusCode(_):
			return nil
		case .codeWithMessage(_, let message):
			return message
		}
	}
}

enum UIError: Error, BSTErrorProtocol {
	case storyboard(String)
	case viewController(String)
	case nib(String)
	case cell(String)
	
	var description: String {
		var desc = ""
		switch self {
		case .storyboard(let name):
			desc = BSTFacade.localizable.errorDebug.storyboard(name)
		case .viewController(let name):
			desc = BSTFacade.localizable.errorDebug.viewController(name)
		case .nib(let name):
			desc = BSTFacade.localizable.errorDebug.nib(name)
		case .cell(let name):
			desc = BSTFacade.localizable.errorDebug.cell(name)
		}
		return desc
	}
	
	func cook(_ object: Any? = nil) {
		BSTFacade.ux.showToastError(self.description)
		
	}
}

enum APIError: Int, Error, BSTErrorProtocol {
	
	case none = -1
	//    case succeed = 200
	//    case succeedOK
	
    case redirection
    
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
	
	//cutom error
	case userExists = 901
	case userNotExists
	case alreadyInUse
	case sessionAlreadyHasBeenDisconnected
	case invalidException
	case invalidToken
	case saveFailed
	//    case accessTokenCouldNotBeDecrypted
	//    case notRegistered(String) = 960
    
    var range: CountableClosedRange<Int> {
        switch self {
        case .redirection:    return 300...399
        default:
            return 0...0
        }
    }

	
	
	var description: String {
		var desc = ""
		switch self {
        case .redirection:
            desc = BSTFacade.localizable.error.networkFailed()
		case .badRequest://400
			desc = BSTFacade.localizable.error.apiBadRequest()
		case .unauthorized: //session expired
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
		case .userNotExists: //902
			desc = BSTFacade.localizable.error.apiUserNotExists()
		case .alreadyInUse: // 903
			desc = BSTFacade.localizable.error.apiAlreadyInUse()
		case .sessionAlreadyHasBeenDisconnected: //904
			desc = BSTFacade.localizable.error.apiAlreadyHasBeenDisconnected()
		case .invalidException: //905
			desc = BSTFacade.localizable.error.apiInvalidException()
		case .invalidToken: //906
			desc = BSTFacade.localizable.error.apiInvalidToken()
		case .saveFailed: //907
			desc = BSTFacade.localizable.error.apiSaveFailed()
			
		default:
			break
		}
		return desc
	}
	
	func cook(_ object: Any? = nil) {
		switch self {
		case .invalidToken:
			BSTFacade.ux.showAlert(BSTFacade.localizable.login.sessionExpired(), {
				BSTFacade.go.login()
			})
		case .userExists, .userNotExists:
			BSTFacade.ux.showAlert(self.description, {
				BSTFacade.go.login()
			})
        case .unauthorized, .sessionAlreadyHasBeenDisconnected:
            BSTFacade.session.tryLoginToBoost()
		default:
			BSTFacade.ux.showAlert(self.description) //alert 출력
		}
	}
}

enum TicketError: Error, BSTErrorProtocol {
	case scanFailed
	case noPermissionForCamera
	case alreadyRegistred
	
	var description: String {
		var desc = ""
		switch self {
		case .scanFailed:
			desc = BSTFacade.localizable.error.ticketScanFailed()    //Resources/Strings/Error.strings에 정의함
		case .noPermissionForCamera:
			desc = BSTFacade.localizable.error.ticketNoPermissionForCamera()
		case .alreadyRegistred:
			desc = BSTFacade.localizable.error.ticketAlreadyRegistred()
		}
		return desc
	}
	
	func cook(_ object: Any? = nil) {
		switch self {
		case .scanFailed:
			let title = BSTFacade.localizable.error.ticketScanFailedTitle()
			BSTFacade.ux.showAlert(self.description, title: title) //alert 출력
		case .noPermissionForCamera:
			BSTFacade.ux.showConfirm(self.description, { (_ ok: Bool?) in
				//카메라 설정으로 이동함.
				if ok ?? false {
					PermissionManager.openAppPermissionSettings()
				}
				
			})
		case .alreadyRegistred:
			let title = BSTFacade.localizable.error.ticketAlreadyRegistredTitle()
			BSTFacade.ux.showConfirm(self.description, title: title, { (_ ok: Bool?) in
				//도움말 화면으로 이동함.
				if ok ?? false {
					guard let topViewController = CommonUtil.getTopVisibleViewController() else {
						return
					}
					BSTFacade.ux.goHelpWebViewController(currentViewController: topViewController)
				}
			})
		}
	}
}

enum PermissionError: Error, BSTErrorProtocol {
	case disableCamera
	case disableBluetooth
	case disablePhotos
	
	var description: String {
		var desc = ""
		switch self {
		case .disableCamera:
			desc = BSTFacade.localizable.error.permissionDisableCamera()    //Resources/Strings/Error.strings에 정의함
		case .disableBluetooth:
			desc = BSTFacade.localizable.error.permissionDisableBluetooth()
		case .disablePhotos:
			desc = BSTFacade.localizable.error.permissionDisablePhotos()
		}
		return desc
	}
	
	func cook(_ object: Any? = nil) {
		switch self {
		default:
			BSTFacade.ux.showAlert(self.description) //alert 출력
		}
	}
}


enum BSTError: Error, BSTErrorProtocol {
	case none
	case isEmpty
	case convertError
	case argumentError
	case nilError
	case unknown
	case typeDismatching
	case api(APIError)
	case white(WhiteError)
	
	case device(DeviceError)
	case ticket(TicketError)
	case debugUI(UIError)
	
	
	
	var description: String {
		var description = ""
		switch self {
		case .isEmpty:
			description = BSTFacade.localizable.error.isEmpty()
		case .convertError:
			description = "convert error"			
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
		case .debugUI(let error):
			description = error.description
			
		default:
			break
		}
		return description
	}
	
	func cookError(_ object: Any? = nil) {
		
		switch self {
		case .api(let error):
			error.cook(error)
		case .device(let error):
			error.cook(object)
		case .ticket(let error):
			error.cook(object)
		case .debugUI(let error):
			error.cook(error)
		default:
			self.cook(object)
		}
	}
}



class BSTErrorTester {
	
	/// 에러가 아니지만 에러 객체를 사용해야 하는 [하아...] 스러운 상황에 사용할 수 있도록 만든 녀석.
	/// checkWhiteCode(error)가 nil이 아니라면, 얘는 오류는 아니지만 결과값이 특별한 그런 녀석인 케이스이다.
	/// response의 값으로는 담겨지지 않는 케이스들을 위해 사용된다.
	@discardableResult
	class func checkWhiteCode(_ err: Error?) -> Int? {
		if let white = err as? WhiteError,
			let code = white.code {
			return code
		}
		if let bstError = err as? BSTError {
			switch bstError {
			case .white(let white):
				// 오류가 아님 (예외)
				return white.code
				
			default:
				return nil
			}
		}
		return nil
	}
	
	/// 간편하게 현재 에러를 체크하여 cook하고 에러여부를 반환
	@discardableResult
	class func isFailure(_ err: Error?) -> Bool {
		guard let error = err else {
			// err is nil
			return false
		}
		
		if let code = checkWhiteCode(err) {
			logDebug("WhiteCode #\(code) doesn't processed. please check BSTErrorTester.checkWhiteCode(err)'s code and exit block. do not call .isFailure with WhiteError.")
			return false
		}
		if let bstError = error as? BSTError {
			logWarning("BSTError : \(error.localizedDescription)")
			bstError.cook()
		}
		logError("error : \(error.localizedDescription)")
		return true
	}
}



class BSTErrorBaker<T> {
	@discardableResult
	class func errorFilter(_ err: Error?, _ response: Response<T>? = nil) -> Error? {
		do {
			try BSTErrorBaker<T>.errorPitcher(err, response)
		} catch let error {
			// !(response?.isBizError ?? false)  === response?.isBizError != true
			// true  -> !(true) == false === false
			// nil   -> !(false) == true === true
			// false -> !(false) == true === true
			
			

			if let apiError = error as? APIError, response?.isBizError != true {
                apiError.cook()
                return nil
            }
			return error
		}
		return err
	}
	
	class func errorPitcher(_ err: Error?, _ response: Response<T>?) throws {
		
		
		
		
		// Alamofire 4 부터는 비정상 호출일 경우, statusCode가 안넘어온다. AFError로 핸들링됨.
		if let errorResponse = err as? ErrorResponse {
			switch(errorResponse) {
			case .error(let code, let data, let error):
				let msg = (data == nil) ? "nil" : String(data: data!, encoding: .utf8) ?? "[unknown data]"
				#if DEBUG
				logError("\(code), \(msg), \(error)")
				#else
				logVerbose("\(code), \(msg), \(error)")
				#endif
				
				if code == 906 {
					// 세션 만료.

					// TODO: 위 errorFilter에서의 isBizError의 범주를 모르겠으나, 900번대중에서도 에러를 처리해야하는경우가 있음. 대표적으로 906. return nil을 해버리면 오류가 없는것으로 간주되어 로그인이 되어버림. 그런 이유로 에러를 그대로 리턴하여 코드레벨에서 처리할 수 있도록 처리.
					SessionHandler.shared.setTokenExpired(true)
		
					if IntroViewController.actual != nil {
						// 인트로 화면에서의 처리.
					} else {
						// 인트로가 아닌 곳에서의 처리. 일단 리턴하여 cook이 알아서 되도록 넘겨준다.
						throw error
					}
					return
					
				}
				if code == 960 {
					try processErrorResponse960(errorResponse, response)
					return
				}
				
//                BSTFacade.ux.showToastError("\(error.localizedDescription)")
				if let api = APIError(rawValue: code) {
                    throw api
					// 906이었나? APIError에 없는게 나오니 무한에러
				} else {
					throw BSTError.white(WhiteError.statusCode(code))
				}
				
				
				//			default:
				//				break	// unknown
			}
		}
		
		if let error = err as? AFError,
			let code = error.responseCode,
			let apiError = APIError(rawValue: code) {
			throw BSTError.api(apiError)
		}
		
		guard let resp = response else {
			
			
			throw err ?? BSTError.nilError
		}
		
		if resp.isNotOk {
			throw BSTError.api(APIError(rawValue: resp.statusCode)!)
		}
	}
	
	

	/// 960 status code 특별 처리
	class func processErrorResponse960(_ errorResponse: ErrorResponse, _ response: Response<T>?) throws {
		switch(errorResponse) {
		case .error(let code, let data, let error):
			guard let dataNonOptional = data, code == 960 else {
				throw BSTError.white(WhiteError.statusCode(code))
			}
			
			var jsonDictionary: [String: Any] = [:]
			var userName = ""
			
			do {
				jsonDictionary = try JSONSerialization.jsonObject(with: dataNonOptional, options: []) as? [String: Any]  ?? [:]
				userName = (jsonDictionary["message"] as? String) ?? ""
				
			} catch let jsonError {
				logError("960 processing erorr : \(error.localizedDescription)")
				throw jsonError
			}
			
			if !userName.isEmpty {
				SessionHandler.shared.welcomeName = userName
			}
			throw BSTError.white(WhiteError.codeWithMessage(code, userName))
		}
	}
	
}
