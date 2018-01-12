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
        
        loadWebUrl("http://boostdev.lysn.com:8181/viewConcert?userId=1&concertId=1")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}


extension DetailConcertInformationViewController {

}
