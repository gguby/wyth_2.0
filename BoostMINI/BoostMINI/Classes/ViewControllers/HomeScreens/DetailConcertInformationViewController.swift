//
//  DetailConcertInformationViewController.swift
//  BoostMINI
//
//  Created by  KoMyeongbu on 2018. 1. 10..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit

class DetailConcertInformationViewController: WebViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userId = (SessionHandler.shared.profile == nil) ? "" : SessionHandler.shared.profile!.id.s
        let lang = DefaultAPI.acceptLanguage    // "ko-KR"    // TODO : 디바이스에 맞게 변경 필요
        let concertId = BSTFacade.session.currentConcertInfo?.concertId
        
        loadWebUrl("http://boostdev.lysn.com:8181/viewConcert?userId=\(userId)&device=IOS&language=\(lang)&concertId=\(concertId)")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}


extension DetailConcertInformationViewController {

}
