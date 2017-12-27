//
//  NilDestination.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 22..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import Crashlytics
import SwiftyBeaver
import UIKit

public class NilDestination: BaseDestination {
    public override var defaultHashValue: Int { return 0 }

    public override init() {
        super.init()
        format = ""
    }

    public override func send(_: SwiftyBeaver.Level, msg _: String, thread _: String,
                              file _: String, function _: String, line _: Int, context _: Any? = nil) -> String? {
        return nil
    }
}
