//
// DefaultAPI.swift
//
// Generated by swagger-codegen
// Modified by dk (dk@devrock.co.kr)
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire
import RxSwift



open class DefaultAPI {
  private static var xAPPVersion: String = BSTApplication.shortVersion ?? "unknown"
  private static var xDevice: String     = "ios"
  private static var acceptLanguage: String = "ko-KR"
    /**
     콘서트 정보 가져오기
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getConcertsUsingGET(completion: @escaping ((_ data: ConcertsGetResponse?,_ error: Error?) -> Void)) {
        getConcertsUsingGETWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, BSTErrorBaker.errorFilter(error, response))
        }
    }

    /**
     콘서트 정보 가져오기
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - returns: Observable<ConcertsGetResponse>
     */
    open class func getConcertsUsingGET() -> Observable<ConcertsGetResponse> {
        return Observable.create { observer -> Disposable in
            getConcertsUsingGET() { data, error in
                if let error = error {
                    observer.on(.error(BSTErrorBaker<Any>.errorFilter(error)!))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     콘서트 정보 가져오기
     - GET /concerts
     - examples: [{output=none}]
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 

     - returns: RequestBuilder<ConcertsGetResponse> 
     */
    open class func getConcertsUsingGETWithRequestBuilder() -> RequestBuilder<ConcertsGetResponse> {
        let path = "/concerts"
        let URLString = BoostMINIAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "X-APP-Version": xAPPVersion,
            "X-Device": xDevice,
            "Accept-Language": acceptLanguage
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<ConcertsGetResponse>.Type = BoostMINIAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     도움말 목록 가져오기
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter lastId: (query)  (optional)
     - parameter size: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getHelplistUsingGET(lastId: Int64? = nil, size: Int32? = nil, completion: @escaping ((_ data: HelpGetResponse?,_ error: Error?) -> Void)) {
        getHelplistUsingGETWithRequestBuilder(lastId: lastId, size: size).execute { (response, error) -> Void in
            completion(response?.body, BSTErrorBaker.errorFilter(error, response))
        }
    }

    /**
     도움말 목록 가져오기
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter lastId: (query)  (optional)
     - parameter size: (query)  (optional)
     - returns: Observable<HelpGetResponse>
     */
    open class func getHelplistUsingGET(lastId: Int64? = nil, size: Int32? = nil) -> Observable<HelpGetResponse> {
        return Observable.create { observer -> Disposable in
            getHelplistUsingGET(lastId: lastId, size: size) { data, error in
                if let error = error {
                    observer.on(.error(BSTErrorBaker<Any>.errorFilter(error)!))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     도움말 목록 가져오기
     - GET /menus/help
     - examples: [{output=none}]
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter lastId: (query)  (optional)
     - parameter size: (query)  (optional)

     - returns: RequestBuilder<HelpGetResponse> 
     */
    open class func getHelplistUsingGETWithRequestBuilder(lastId: Int64? = nil, size: Int32? = nil) -> RequestBuilder<HelpGetResponse> {
        let path = "/menus/help"
        let URLString = BoostMINIAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "lastId": lastId?.encodeToJSON(), 
            "size": size?.encodeToJSON()
        ])
        
        let nillableHeaders: [String: Any?] = [
            "X-APP-Version": xAPPVersion,
            "X-Device": xDevice,
            "Accept-Language": acceptLanguage
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<HelpGetResponse>.Type = BoostMINIAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     알림 리스트 가져오기
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter lastId: (query)  (optional)
     - parameter size: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNoticesUsingGET(lastId: Int64? = nil, size: Int32? = nil, completion: @escaping ((_ data: NoticesGetResponse?,_ error: Error?) -> Void)) {
        getNoticesUsingGETWithRequestBuilder(lastId: lastId, size: size).execute { (response, error) -> Void in
            completion(response?.body, BSTErrorBaker.errorFilter(error, response))
        }
    }

    /**
     알림 리스트 가져오기
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter lastId: (query)  (optional)
     - parameter size: (query)  (optional)
     - returns: Observable<NoticesGetResponse>
     */
    open class func getNoticesUsingGET(lastId: Int64? = nil, size: Int32? = nil) -> Observable<NoticesGetResponse> {
        return Observable.create { observer -> Disposable in
            getNoticesUsingGET(lastId: lastId, size: size) { data, error in
                if let error = error {
                    observer.on(.error(BSTErrorBaker<Any>.errorFilter(error)!))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     알림 리스트 가져오기
     - GET /notices
     - examples: [{output=none}]
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter lastId: (query)  (optional)
     - parameter size: (query)  (optional)

     - returns: RequestBuilder<NoticesGetResponse> 
     */
    open class func getNoticesUsingGETWithRequestBuilder(lastId: Int64? = nil, size: Int32? = nil) -> RequestBuilder<NoticesGetResponse> {
        let path = "/notices"
        let URLString = BoostMINIAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "lastId": lastId?.encodeToJSON(), 
            "size": size?.encodeToJSON()
        ])
        
        let nillableHeaders: [String: Any?] = [
            "X-APP-Version": xAPPVersion,
            "X-Device": xDevice,
            "Accept-Language": acceptLanguage
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<NoticesGetResponse>.Type = BoostMINIAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     회원 정보
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getProfileUsingGET(completion: @escaping ((_ data: ProfileGetResponse?,_ error: Error?) -> Void)) {
        getProfileUsingGETWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, BSTErrorBaker.errorFilter(error, response))
        }
    }

    /**
     회원 정보
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - returns: Observable<ProfileGetResponse>
     */
    open class func getProfileUsingGET() -> Observable<ProfileGetResponse> {
        return Observable.create { observer -> Disposable in
            getProfileUsingGET() { data, error in
                if let error = error {
                    observer.on(.error(BSTErrorBaker<Any>.errorFilter(error)!))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     회원 정보
     - GET /accounts/profile
     - examples: [{output=none}]
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 

     - returns: RequestBuilder<ProfileGetResponse> 
     */
    open class func getProfileUsingGETWithRequestBuilder() -> RequestBuilder<ProfileGetResponse> {
        let path = "/accounts/profile"
        let URLString = BoostMINIAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "X-APP-Version": xAPPVersion,
            "X-Device": xDevice,
            "Accept-Language": acceptLanguage
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<ProfileGetResponse>.Type = BoostMINIAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     * enum for parameter type
     */
    public enum ModelType_getSeatsUsingGET: String { 
        case interpark = "INTERPARK"
        case yes24 = "YES24"
    }

    /**
     콘서트 좌석 정보 조회
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter type: (path) type 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getSeatsUsingGET(type: ModelType_getSeatsUsingGET, completion: @escaping ((_ data: ConcertsSeatGetResponse?,_ error: Error?) -> Void)) {
        getSeatsUsingGETWithRequestBuilder(type: type).execute { (response, error) -> Void in
            completion(response?.body, BSTErrorBaker.errorFilter(error, response))
        }
    }

    /**
     콘서트 좌석 정보 조회
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter type: (path) type 
     - returns: Observable<ConcertsSeatGetResponse>
     */
    open class func getSeatsUsingGET(type: ModelType_getSeatsUsingGET) -> Observable<ConcertsSeatGetResponse> {
        return Observable.create { observer -> Disposable in
            getSeatsUsingGET(type: type) { data, error in
                if let error = error {
                    observer.on(.error(BSTErrorBaker<Any>.errorFilter(error)!))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     콘서트 좌석 정보 조회
     - GET /concerts/seat/{type}
     - examples: [{output=none}]
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter type: (path) type 

     - returns: RequestBuilder<ConcertsSeatGetResponse> 
     */
    open class func getSeatsUsingGETWithRequestBuilder(type: ModelType_getSeatsUsingGET) -> RequestBuilder<ConcertsSeatGetResponse> {
        var path = "/concerts/seat/{type}"
        path = path.replacingOccurrences(of: "{type}", with: "\(type.rawValue)", options: .literal, range: nil)
        let URLString = BoostMINIAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "X-APP-Version": xAPPVersion,
            "X-Device": xDevice,
            "Accept-Language": acceptLanguage
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<ConcertsSeatGetResponse>.Type = BoostMINIAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     설정 정보 가져오기
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getSettingsUsingGET(completion: @escaping ((_ data: SettingsGetResponse?,_ error: Error?) -> Void)) {
        getSettingsUsingGETWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, BSTErrorBaker.errorFilter(error, response))
        }
    }

    /**
     설정 정보 가져오기
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - returns: Observable<SettingsGetResponse>
     */
    open class func getSettingsUsingGET() -> Observable<SettingsGetResponse> {
        return Observable.create { observer -> Disposable in
            getSettingsUsingGET() { data, error in
                if let error = error {
                    observer.on(.error(BSTErrorBaker<Any>.errorFilter(error)!))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     설정 정보 가져오기
     - GET /settings
     - examples: [{output=none}]
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 

     - returns: RequestBuilder<SettingsGetResponse> 
     */
    open class func getSettingsUsingGETWithRequestBuilder() -> RequestBuilder<SettingsGetResponse> {
        let path = "/settings"
        let URLString = BoostMINIAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "X-APP-Version": xAPPVersion,
            "X-Device": xDevice,
            "Accept-Language": acceptLanguage
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<SettingsGetResponse>.Type = BoostMINIAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     앱 버전 정보 가져오기
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getVersionUsingGET(completion: @escaping ((_ data: AppsGetResponse?,_ error: Error?) -> Void)) {
        getVersionUsingGETWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, BSTErrorBaker.errorFilter(error, response))
        }
    }

    /**
     앱 버전 정보 가져오기
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - returns: Observable<AppsGetResponse>
     */
    open class func getVersionUsingGET() -> Observable<AppsGetResponse> {
        return Observable.create { observer -> Disposable in
            getVersionUsingGET() { data, error in
                if let error = error {
                    observer.on(.error(BSTErrorBaker<Any>.errorFilter(error)!))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     앱 버전 정보 가져오기
     - GET /apps/version
     - examples: [{output=none}]
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 

     - returns: RequestBuilder<AppsGetResponse> 
     */
    open class func getVersionUsingGETWithRequestBuilder() -> RequestBuilder<AppsGetResponse> {
        let path = "/apps/version"
        let URLString = BoostMINIAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "X-APP-Version": xAPPVersion,
            "X-Device": xDevice,
            "Accept-Language": acceptLanguage
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<AppsGetResponse>.Type = BoostMINIAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     알림 설정
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter alarm: (body) alarm 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postAlarmsUsingPOST(alarm: Bool, completion: @escaping ((_ data: CommonBooleanGetResponse?,_ error: Error?) -> Void)) {
        postAlarmsUsingPOSTWithRequestBuilder(alarm: alarm).execute { (response, error) -> Void in
            completion(response?.body, BSTErrorBaker.errorFilter(error, response))
        }
    }

    /**
     알림 설정
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter alarm: (body) alarm 
     - returns: Observable<CommonBooleanGetResponse>
     */
    open class func postAlarmsUsingPOST(alarm: Bool) -> Observable<CommonBooleanGetResponse> {
        return Observable.create { observer -> Disposable in
            postAlarmsUsingPOST(alarm: alarm) { data, error in
                if let error = error {
                    observer.on(.error(BSTErrorBaker<Any>.errorFilter(error)!))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     알림 설정
     - POST /settings/alarm
     - examples: [{output=none}]
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter alarm: (body) alarm 

     - returns: RequestBuilder<CommonBooleanGetResponse> 
     */
    open class func postAlarmsUsingPOSTWithRequestBuilder(alarm: Bool) -> RequestBuilder<CommonBooleanGetResponse> {
        let path = "/settings/alarm"
        let URLString = BoostMINIAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: alarm)

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "X-APP-Version": xAPPVersion,
            "X-Device": xDevice,
            "Accept-Language": acceptLanguage
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<CommonBooleanGetResponse>.Type = BoostMINIAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters)
    }

    /**
     스킨 선택 설정
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter select: (body) select 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postSkinsUsingPOST(select: Int32, completion: @escaping ((_ data: CommonNumberGetResponse?,_ error: Error?) -> Void)) {
        postSkinsUsingPOSTWithRequestBuilder(select: select).execute { (response, error) -> Void in
            completion(response?.body, BSTErrorBaker.errorFilter(error, response))
        }
    }

    /**
     스킨 선택 설정
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter select: (body) select 
     - returns: Observable<CommonNumberGetResponse>
     */
    open class func postSkinsUsingPOST(select: Int32) -> Observable<CommonNumberGetResponse> {
        return Observable.create { observer -> Disposable in
            postSkinsUsingPOST(select: select) { data, error in
                if let error = error {
                    observer.on(.error(BSTErrorBaker<Any>.errorFilter(error)!))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     스킨 선택 설정
     - POST /settings/skin
     - examples: [{output=none}]
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter select: (body) select 

     - returns: RequestBuilder<CommonNumberGetResponse> 
     */
    open class func postSkinsUsingPOSTWithRequestBuilder(select: Int32) -> RequestBuilder<CommonNumberGetResponse> {
        let path = "/settings/skin"
        let URLString = BoostMINIAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: select)

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "X-APP-Version": xAPPVersion,
            "X-Device": xDevice,
            "Accept-Language": acceptLanguage
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<CommonNumberGetResponse>.Type = BoostMINIAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters)
    }

    /**
     showResponseCode
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func showResponseCodeUsingHEAD(completion: @escaping ((_ data: String?,_ error: Error?) -> Void)) {
        showResponseCodeUsingHEADWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, BSTErrorBaker.errorFilter(error, response))
        }
    }

    /**
     showResponseCode
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - returns: Observable<String>
     */
    open class func showResponseCodeUsingHEAD() -> Observable<String> {
        return Observable.create { observer -> Disposable in
            showResponseCodeUsingHEAD() { data, error in
                if let error = error {
                    observer.on(.error(BSTErrorBaker<Any>.errorFilter(error)!))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     showResponseCode
     - HEAD /swagger/response/code
     - examples: [{output=none}]
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 

     - returns: RequestBuilder<String> 
     */
    open class func showResponseCodeUsingHEADWithRequestBuilder() -> RequestBuilder<String> {
        let path = "/swagger/response/code"
        let URLString = BoostMINIAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "X-APP-Version": xAPPVersion,
            "X-Device": xDevice,
            "Accept-Language": acceptLanguage
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<String>.Type = BoostMINIAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "HEAD", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     * enum for parameter socialType
     */
    public enum SocialType_signinUsingPOST: String { 
        case smtown = "SMTOWN"
        case facebook = "FACEBOOK"
        case twitter = "TWITTER"
        case google = "GOOGLE"
    }

    /**
     로그인
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter accessToken: (query)  
     - parameter socialType: (query)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func signinUsingPOST(accessToken: String, socialType: SocialType_signinUsingPOST, completion: @escaping ((_ data: AccountsPostResponse?,_ error: Error?) -> Void)) {
        signinUsingPOSTWithRequestBuilder(accessToken: accessToken, socialType: socialType).execute { (response, error) -> Void in
            completion(response?.body, BSTErrorBaker.errorFilter(error, response))
        }
    }

    /**
     로그인
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter accessToken: (query)  
     - parameter socialType: (query)  
     - returns: Observable<AccountsPostResponse>
     */
    open class func signinUsingPOST(accessToken: String, socialType: SocialType_signinUsingPOST) -> Observable<AccountsPostResponse> {
        return Observable.create { observer -> Disposable in
            signinUsingPOST(accessToken: accessToken, socialType: socialType) { data, error in
                if let error = error {
                    observer.on(.error(BSTErrorBaker<Any>.errorFilter(error)!))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     로그인
     - POST /accounts/signin
     - examples: [{output=none}]
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter accessToken: (query)  
     - parameter socialType: (query)  

     - returns: RequestBuilder<AccountsPostResponse> 
     */
    open class func signinUsingPOSTWithRequestBuilder(accessToken: String, socialType: SocialType_signinUsingPOST) -> RequestBuilder<AccountsPostResponse> {
        let path = "/accounts/signin"
        let URLString = BoostMINIAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "accessToken": accessToken, 
            "socialType": socialType.rawValue
        ])
        
        let nillableHeaders: [String: Any?] = [
            "X-APP-Version": xAPPVersion,
            "X-Device": xDevice,
            "Accept-Language": acceptLanguage
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<AccountsPostResponse>.Type = BoostMINIAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     로그아웃
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func signoutUsingDELETE(completion: @escaping ((_ error: Error?) -> Void)) {
        signoutUsingDELETEWithRequestBuilder().execute { (response, error) -> Void in
            completion(error);
        }
    }

    /**
     로그아웃
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - returns: Observable<Void>
     */
    open class func signoutUsingDELETE() -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            signoutUsingDELETE() { error in
                if let error = error {
                    observer.on(.error(BSTErrorBaker<Any>.errorFilter(error)!))
                } else {
                    // observer.on(.next())
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     로그아웃
     - DELETE /accounts/signout
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 

     - returns: RequestBuilder<Void> 
     */
    open class func signoutUsingDELETEWithRequestBuilder() -> RequestBuilder<Void> {
        let path = "/accounts/signout"
        let URLString = BoostMINIAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "X-APP-Version": xAPPVersion,
            "X-Device": xDevice,
            "Accept-Language": acceptLanguage
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = BoostMINIAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     * enum for parameter socialType
     */
    public enum SocialType_signupUsingPOST: String { 
        case smtown = "SMTOWN"
        case facebook = "FACEBOOK"
        case twitter = "TWITTER"
        case google = "GOOGLE"
    }

    /**
     회원 가입
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter accessToken: (query)  
     - parameter socialType: (query)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func signupUsingPOST(accessToken: String, socialType: SocialType_signupUsingPOST, completion: @escaping ((_ data: AccountsPostResponse?,_ error: Error?) -> Void)) {
        signupUsingPOSTWithRequestBuilder(accessToken: accessToken, socialType: socialType).execute { (response, error) -> Void in
            completion(response?.body, BSTErrorBaker.errorFilter(error, response))
        }
    }

    /**
     회원 가입
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter accessToken: (query)  
     - parameter socialType: (query)  
     - returns: Observable<AccountsPostResponse>
     */
    open class func signupUsingPOST(accessToken: String, socialType: SocialType_signupUsingPOST) -> Observable<AccountsPostResponse> {
        return Observable.create { observer -> Disposable in
            signupUsingPOST(accessToken: accessToken, socialType: socialType) { data, error in
                if let error = error {
                    observer.on(.error(BSTErrorBaker<Any>.errorFilter(error)!))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     회원 가입
     - POST /accounts/signup
     - examples: [{output=none}]
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter accessToken: (query)  
     - parameter socialType: (query)  

     - returns: RequestBuilder<AccountsPostResponse> 
     */
    open class func signupUsingPOSTWithRequestBuilder(accessToken: String, socialType: SocialType_signupUsingPOST) -> RequestBuilder<AccountsPostResponse> {
        let path = "/accounts/signup"
        let URLString = BoostMINIAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "accessToken": accessToken, 
            "socialType": socialType.rawValue
        ])
        
        let nillableHeaders: [String: Any?] = [
            "X-APP-Version": xAPPVersion,
            "X-Device": xDevice,
            "Accept-Language": acceptLanguage
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<AccountsPostResponse>.Type = BoostMINIAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     탈퇴
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func withdrawUsingDELETE(completion: @escaping ((_ error: Error?) -> Void)) {
        withdrawUsingDELETEWithRequestBuilder().execute { (response, error) -> Void in
            completion(error);
        }
    }

    /**
     탈퇴
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - returns: Observable<Void>
     */
    open class func withdrawUsingDELETE() -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            withdrawUsingDELETE() { error in
                if let error = error {
                    observer.on(.error(BSTErrorBaker<Any>.errorFilter(error)!))
                } else {
                    // observer.on(.next())
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     탈퇴
     - DELETE /accounts/withdraw
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 

     - returns: RequestBuilder<Void> 
     */
    open class func withdrawUsingDELETEWithRequestBuilder() -> RequestBuilder<Void> {
        let path = "/accounts/withdraw"
        let URLString = BoostMINIAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "X-APP-Version": xAPPVersion,
            "X-Device": xDevice,
            "Accept-Language": acceptLanguage
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = BoostMINIAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

}