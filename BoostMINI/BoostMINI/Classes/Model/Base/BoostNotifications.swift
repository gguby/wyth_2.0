//
//  BoostNotifications.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 15..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import Foundation

protocol NotificationName {
	var name: Notification.Name { get }
}

extension RawRepresentable where RawValue == String, Self: NotificationName {
	var name: Notification.Name {
		return Notification.Name(self.rawValue)
	}
}

enum BoostNotificationLogin : String, NotificationName {
	case failed
	case needRegister
	case registered
	case login
	case logout
}

