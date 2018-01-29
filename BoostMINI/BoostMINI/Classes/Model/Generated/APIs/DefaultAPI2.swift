//
// _API.swift
//
// Generated by swagger-codegen
// Modified by dk (dk@devrock.co.kr)
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire
import RxSwift



extension DefaultAPI {
    /**
     알림 리스트 가져오기
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter lastId: (query)  (optional)
     - parameter size: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNoticesUsingGET(lastId: Int64? = nil, size: Int? = nil, completion: @escaping ((_ data: NoticesGetResponse?,_ error: Error?) -> Void)) {
		BSTFacade.ux.showIndicator(uniqueIndicatorKey)
        getNoticesUsingGETWithRequestBuilder(lastId: lastId, size: size).execute { (response, error) -> Void in
		BSTFacade.ux.hideIndicator(uniqueIndicatorKey)
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
    open class func getNoticesUsingGET(lastId: Int64? = nil, size: Int? = nil) -> Observable<NoticesGetResponse> {
        return Observable.create { observer -> Disposable in
            getNoticesUsingGET(lastId: lastId, size: size) { data, error in
                guard let data = data else { 
                    observer.on(.error(BSTError.isEmpty)) 
                    return 
                } 
                if let error = error { 
                    observer.on(.error(error)) 
                } else { 
                    observer.on(.next(data)) 
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
    open class func getNoticesUsingGETWithRequestBuilder(lastId: Int64? = nil, size: Int? = nil) -> RequestBuilder<NoticesGetResponse> {
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
     앱 버전 정보 가져오기
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getVersionUsingGET(completion: @escaping ((_ data: AppsGetResponse?,_ error: Error?) -> Void)) {
		BSTFacade.ux.showIndicator(uniqueIndicatorKey)
        getVersionUsingGETWithRequestBuilder().execute { (response, error) -> Void in
		BSTFacade.ux.hideIndicator(uniqueIndicatorKey)
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
                    observer.on(.error(error))
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
     알림 읽기 여부 상태 변경
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter id: (path) id 
     - parameter read: (path) read 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postNoticesReadUsingPOST(id: Int, read: Bool, completion: @escaping ((_ error: Error?) -> Void)) {
		BSTFacade.ux.showIndicator(uniqueIndicatorKey)
        postNoticesReadUsingPOSTWithRequestBuilder(id: id, read: read).execute { (response, error) -> Void in
		BSTFacade.ux.hideIndicator(uniqueIndicatorKey)
            completion(error);
        }
    }

    /**
     알림 읽기 여부 상태 변경
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter id: (path) id 
     - parameter read: (path) read 
     - returns: Observable<Void>
     */
    open class func postNoticesReadUsingPOST(id: Int, read: Bool) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            postNoticesReadUsingPOST(id: id, read: read) { error in
                if let error = error {
                    observer.on(.error(error))
                } else {
                    observer.on(.next(()))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     알림 읽기 여부 상태 변경
     - POST /notices/{id}/{read}
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter id: (path) id 
     - parameter read: (path) read 

     - returns: RequestBuilder<Void> 
     */
    open class func postNoticesReadUsingPOSTWithRequestBuilder(id: Int, read: Bool) -> RequestBuilder<Void> {
        var path = "/notices/{id}/{read}"
        path = path.replacingOccurrences(of: "{id}", with: "\(id)", options: .literal, range: nil)
        path = path.replacingOccurrences(of: "{read}", with: "\(read)", options: .literal, range: nil)
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

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     showResponseCode
     
     - parameter xAPPVersion: (header) app version 
     - parameter xDevice: (header) device/os information (informal) 
     - parameter acceptLanguage: (header) language-locale 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func showResponseCodeUsingHEAD(completion: @escaping ((_ data: String?,_ error: Error?) -> Void)) {
		BSTFacade.ux.showIndicator(uniqueIndicatorKey)
        showResponseCodeUsingHEADWithRequestBuilder().execute { (response, error) -> Void in
		BSTFacade.ux.hideIndicator(uniqueIndicatorKey)
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
                    observer.on(.error(error))
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

}
