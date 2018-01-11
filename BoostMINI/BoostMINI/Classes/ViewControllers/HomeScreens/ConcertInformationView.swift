//
//  ConcertInformationView.swift
//  BoostMINI
//
//  Created by  KoMyeongbu on 2018. 1. 3..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit


class ConcertInformationView: UIView {
    
    @IBOutlet weak var ddayLabel: UILabel!
    @IBOutlet weak var concertNameLabel: UILabel!
    @IBOutlet weak var concertDateLabel: UILabel!
    @IBOutlet weak var concertPlaceLabel: UILabel!
    
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var topTiltingView: TopTiltingView!
    @IBOutlet weak var detailConcertInformationButton: UIButton!
    
   
    class func instanceFromNib() -> ConcertInformationView {
        return UINib(nibName: "ConcertInformationView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ConcertInformationView
    }
    
    func updateConcertInfo() {
        DefaultAPI.getConcertsUsingGET { [weak self] body, err in
            guard let data = body else {
                return
            }
            
            self?.ddayLabel.text = "D-\(data.dday!)"
            self?.concertNameLabel.text = data.concertPlace
            self?.concertDateLabel.text = data.concertDate
            self?.concertPlaceLabel.text = "@\(data.concertPlace!)"
        }
    }
    
    func updateConcerSeatInfo() {
        DefaultAPI.getSeatsUsingGET(type: .yes24) { [weak self] body, err in
            guard let data = body else {
                return
            }
            
        }
    }
    
}



