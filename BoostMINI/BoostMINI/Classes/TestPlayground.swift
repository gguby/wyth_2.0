//
//  TestPlayground.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 19..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit

/// 놀자!
#if DEBUG
	class TestPlayground {
		let callerVC: UIViewController!
		let button: UIButton?
		
		init(_ from:UIViewController, _ on:UIButton? ) {
			callerVC = from
			button = on
		}
		func enjoy(_ index: Int) {
			[enjoy1, enjoy2, enjoy3, enjoy4][index]()	// ㅋㅋㅋㅋ. 아니오! 없어요!
		}
		
		func enjoy1() {
			//case 1:
			// 인디게이터 강제로 표시.
			BSTFacade.ux.showIndicator()
		} // it was enjoy1. Thank you!
		
		func enjoy2() {
			//case 2:
			// 공지를 가져와서 뿌림.
			DefaultAPI.getNoticesUsingGET(lastId: 0, size: 10, completion: { resp, _ in
				dump(resp)	// error는 dump하지 않아도 이미 자동적으로 콘솔에 찍힌다.
			})
		} // it was enjoy2
		
		func enjoy3() {
			// 스킨을 2번으로 서버에 보냄. (보내기만 하므로, 실제 현재 화면이 실시간으로 바뀌지는 않음.)
			DefaultAPI.postSkinsUsingPOST(select: 2, completion: { resp, _ in
				dump(resp)	// error는 dump하지 않아도 이미 자동적으로 콘솔에 찍힌다.
			})
		} // it was enjoy3
		
		func enjoy4() {
			// 랜덤한 숫자를 토스트로뿌림
			BSTFacade.ux.showToast("\(arc4random())" )
		} // it was enjoy4
	}
	
	
#endif
