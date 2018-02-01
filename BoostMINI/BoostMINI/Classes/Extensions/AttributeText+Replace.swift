//
//  AttributeText+Replace.swift
//  BoostMINI
//
//  Created by jack on 2018. 2. 1..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit

extension NSAttributedString {
	/// 속성은 유지한 채 전체 문자열 치환. (밑줄 등의 개개별 속성도 유지)
	///
	/// - Parameter text: 새로운 텍스트
	/// - Returns: 새로운 어트리뷰티드텍스트
	func replacedText(_ text: String) -> NSAttributedString? {
		
		let mutableAttributedText = text.mutableCopy()
		guard let mutableString = (mutableAttributedText as AnyObject).mutableString else {
			print("Error in replacedText() in NSAttributedString : \(text)")
			
			return self
		}
		
		let len = self.string.length()
		let range = NSMakeRange(0, len)
		//mutableString.setString(text)
		mutableString.replaceCharacters(in: range, with: text)
		
		return mutableAttributedText as? NSAttributedString
	}
	
}
extension UILabel {
	
	/// Attributed Text를 사용할 때, Attribute를 그대로 유지한 채 스트링만 변경합니다.
	/// get : 일반 스트링을 반환
	/// set : 기존 속성을 유지한 채 스트링만 replace 함. 단, 기존에 속성을 사용하지 않은 Plain 텍스트일 경우는 그냥 텍스트만 변경함.
	var textContent: String? {
		get {
			return text
		}
		set {
			guard let original = self.attributedText else {
				self.text = newValue
				return
			}
			guard let text = newValue else {
				self.attributedText = nil
				return
			}
			self.attributedText = original.replacedText(text)
		}
	}
}



extension UIButton {
	
	/// Attributed Text를 사용할 때, Attribute를 그대로 유지한 채 스트링만 변경합니다.
	/// get : 일반 스트링을 반환. (.normal을 반환합니다.)
	/// set : 기존 속성을 유지한 채 스트링만 replace 함. 단, 기존에 속성을 사용하지 않은 Plain 텍스트일 경우는 그냥 텍스트만 변경함.
	/// 버튼에서 textContent를 사용하게 되면, 스트링이 지정된 모든 속성에 대해 업데이트 됩니다.
	/// 즉, .normal만 스트링을 지정했다면 해당 스트링만 변경되고, .normal, .disabled 텍스트를 지정했다면 두 텍스트가 모두 변경됩니다.
	var textContent: String? {
		get {
			return self.title(for: .normal)
		}
		set {
			for state: UIControlState in [.normal, .selected, .highlighted, .disabled] {
				guard let original = self.attributedTitle(for: state) else {
					if self.title(for: state) == nil {
						// 기존 스트링이 아예 존재하지 않으면 (속성, 일반)
						self.setTitle(newValue, for: state)
					}
					continue
				}
				guard let text = newValue else {
					self.setTitle(nil, for: .normal)
					continue
				}
				self.setAttributedTitle(original.replacedText(text), for: state)
			}
		}
	}
	
	func setTitleContent(_ title: String?, for state: UIControlState) {
		guard let original = self.attributedTitle(for: state) else {
			if self.title(for: state) == nil {
				self.setTitle(title, for: state)
			}
			return
		}
		guard let text = title else {
			self.setTitle(nil, for: state)
			return
		}
		self.setAttributedTitle(original.replacedText(text), for: state)
	}
}
