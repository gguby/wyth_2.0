//
//  PermissionSet+Default.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 16..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit
import Permission

extension Permission {
	static var base: [Permission] {

		#if TARGET_OS_SIMULATOR
			// 시뮬은 블루투스, 푸쉬를 지원안함
			return [.camera, .photos]
		#endif

		return [.camera, .bluetooth, .notifications, .photos]
	}
}
