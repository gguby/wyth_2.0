//
//  ConcertInfoView.swift
//  BoostMINI
//
//  Created by wsjung on 2018. 1. 10..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit


class ConcertInfoView : UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var seatLbl: UILabel!
    
    @IBOutlet weak var floor: UILabel!
    @IBOutlet weak var region: UILabel!
    @IBOutlet weak var column: UILabel!
    @IBOutlet weak var number: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInitialization()
    }
    
    func commonInitialization() {
        Bundle.main.loadNibNamed("ConcertInfoView", owner: self, options: nil)
        
        self.addSubview(contentView)
        contentView.frame = self.bounds
        
        self.titleLbl.text = R.string.common.concertInfoTitle()
        self.seatLbl.text = R.string.common.concertInfoSeat()
        self.dateLbl.text = "2018.02.01.FRI 19:00"
        
        DispatchQueue.main.async {
            self.getConcertData()
        }
    }
    
    func getConcertData() {
		let concertId = "??"
		DefaultAPI.getSeatsUsingGET(concertId: concertId) { [weak self] response, _ in
            guard let response = response else { return }

		    //self?.dateLbl.text = response.concertDate
            self?.floor.text = response.floor
            self?.region.text = response.zone
            self?.column.text = response.row
            self?.number.text = response.column
            
            BSTFacade.session.seat = response
        }
    }

}
