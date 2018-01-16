////
////  UIViewController+Storyboard.swift
////  BoostMINI
////
////  Created by jack on 2018. 1. 2..
////  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
////
//
//import UIKit
//
//extension UIViewController {
//	
//	fileprivate class var identifier: String { return String(describing: self) }
//	
//	public func getMyClassIdentifier() -> String {
//		return self.typeName
//	}
//
//	
//	class func create(_ storyboardName: String? = nil) -> Self {
//		return try! _create(self, storyboardName)
//	}
//	
//	fileprivate class func _create<T: UIViewController>(_ type: T.Type, _ storyboardName: String?) throws -> T {
//		guard var storyboardFilename = storyboardName ?? identifier.components(separatedBy: .upper).first else {
//			BSTFacade.ux.showToast(BSTFacade.localizable.error.viewControllerMissing("Home.initialViewController"))
//			throw BSTError.argumentError
//		}
//		
//		if storyboardFilename.isEmpty {
//			storyboardFilename = "Main"
//		}
//		
//		let storyboard = UIStoryboard(name: storyboardFilename, bundle: nil)
//
//		// storyboard ID가 VC이름과 동일하게 존재해야만 제대로 읽어온다.
//		let vc = storyboard.instantiateViewController(withIdentifier: identifier)
//		guard let vct = vc as? T else {
//			let tmp = CommonUtil.getTypeName(T().getTypeName())
//			BSTFacade.ux.showToast(BSTFacade.localizable.error.viewControllerMissing(tmp))
//			throw BSTError.argumentError
//		}
//		
//		return vct
//	}
//}

