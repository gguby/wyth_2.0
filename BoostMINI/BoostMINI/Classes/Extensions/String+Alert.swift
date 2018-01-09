//
//  String+Alert.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 9..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit

extension String {
	
	/// 현재 문자열을 메시지로 하는 일반 알럿 메시지를 띄움
	public func showAlert(completion: (() -> Void)? = nil) {
		BSTFacade.ux.showAlert(self) {
			completion?()
		}
	}
	
	/// 현재 문자열을 메시지로 하는 일반 알럿 메시지를 띄움
	public func showToast() {
		BSTFacade.ux.showToast(self)
	}

}
