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
	static var defaultSet: [Permission] {

		if BSTDeviceType.isSimulator {
			// 시뮬은 블루투스, 푸쉬를 지원안함, 카메라도 안할텐데요?
			return [.photos]
		}

		return [.camera, .bluetooth, .notifications, .photos]
	}
}
