//
//  Logger+AlamofireRequest.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 19..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import Foundation
import Alamofire



/// codegen으로 생성되고 박동권(jack)이 만든 codegenRestAPI.sh 에서 연동되는 로그 함수.
/// 로그를 보기 싫다면 여기 함수 내부를 변경하거나 등등 하시면 됨.
/// - Parameter request: DataRequest
func logRequest(_ request: DataRequest) {
	let text = request.debugDescription

	print("\n\(text)")
	//logVerbose(text)
}

extension Logger {

}
