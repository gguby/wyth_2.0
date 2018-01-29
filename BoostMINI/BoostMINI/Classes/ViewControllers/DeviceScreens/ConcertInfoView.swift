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
    
    var disposeBag = DisposeBag()
    
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
        
        self.getConcertData()
    }
    
    func getConcertData() {
        guard let concertId = BSTFacade.session.currentConcertInfo?.concertId else { return }
        
        let observable = DefaultAPI.getSeatsUsingGET(concertId: concertId)
        
        observable.map { $0.floor }.bind(to: self.floor.rx.text).disposed(by: self.disposeBag)
        observable.map { $0.zone }.bind(to: self.region.rx.text).disposed(by: self.disposeBag)
        observable.map { $0.row }.bind(to: self.column.rx.text).disposed(by: self.disposeBag)
        observable.map { $0.column }.bind(to: self.number.rx.text).disposed(by: self.disposeBag)
    }

}
