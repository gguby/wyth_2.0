//
//  Theme.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 4..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit
import Rswift

final class BST {
}

extension BST {
	final class Theme {
		
		typealias image = R.image

		// color의 경우, 팔레트 연결되는 컬러가 clr이다. 파일명이 BoostMINI.clr 이므로 해당 struct에 바로 연결한다.
		// 참고로 이게 프로젝트에 속해있어야 generate된다. 그런 이유로 BoostMini.clr이 프로젝트에 포함되었다.
		//typealias color = R.color
		typealias color = R.clr.boostMini
		
		private init() { }
	}
	
}
