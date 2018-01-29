//
//  ConcertInformationView.swift
//  BoostMINI
//
//  Created by  KoMyeongbu on 2018. 1. 3..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit


class ConcertInformationView: UIView {
    @IBOutlet weak var concertInfoView: UIView!
    
    @IBOutlet weak var ddayLabel: UILabel!
    @IBOutlet weak var concertNameLabel: UILabel!
    @IBOutlet weak var concertDateLabel: UILabel!
    @IBOutlet weak var concertPlaceLabel: UILabel!
    
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var topTiltingView: TopTiltingView!
    @IBOutlet weak var detailConcertInformationButton: UIButton!
    
    @IBOutlet weak var connectStatusLabel: UILabel!
    @IBOutlet weak var viewingDateLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var rowLabel: UILabel!
    @IBOutlet weak var seatNumberLabel: UILabel!
    
    @IBOutlet weak var ddayLabelWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var ddayLabelHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var concertNameLabelHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var concertDateLabelHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var concertPlaceLabelHeightConstant: NSLayoutConstraint!
    
    var homeViewController : HomeViewController?
    
    @IBAction func goDevice(_ sender: Any) {
        BSTFacade.ux.goDevice(self.homeViewController, type: ReactorViewType.Management)
    }
    
    let smtownFontAttribute = [ NSAttributedStringKey.font: UIFont(name: "SMTOWNOTF-Medium", size: 16.0)! ]
    
    class func instanceFromNib() -> ConcertInformationView {
        return UINib(nibName: "ConcertInformationView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ConcertInformationView
    }
    
    func updateConcertInfo() {
        DefaultAPI.getConcertsUsingGET { [weak self] body, err in
            guard let dataList = body,
				let data = dataList.concertlist?.last else {
                return
            }
			BSTFacade.session.currentConcertInfo = data
			
            self?.ddayLabel.text = "D-\(data.dday!)"
            self?.concertNameLabel.text = data.concertNm
            self?.concertDateLabel.text = data.concertDate
            self?.concertPlaceLabel.text = "@\(data.concertPlace!)"
			
			//TODO : API 변경 대응...
			if data.end == true {
            //if data.concertStatus == .end {
                self?.ddayLabel.text = "END"
                self?.ddayLabel.backgroundColor = R.clr.boostMini.commonBgDefault()
                self?.detailConcertInformationButton.backgroundColor = R.clr.boostMini.commonBgDefault()
                self?.closeConcertSeatInfo()
            }
            
            //self?.updateConcertInfo()	// 무한 재귀 호출
        }
    }
    
    func updateConcerSeatInfo() {
		//TODO : type이 삭제되고, concertId가 추가되었습니다..
		let concertId = BSTFacade.session.currentConcertInfo?.concertId
        DefaultAPI.getSeatsUsingGET(concertId: concertId!) { [weak self] body, err in
            guard let data = body else {
                return
            }
            var range = NSRange()
			
			// data가 다 바뀌었습니다. 확인 부탁드립니다. (아래 주석 제거후 확인)
//            self?.viewingDateLabel.text = data.

            range = NSRange.init(location: 0, length: (data.floor?.length())!)
            let floorString = NSMutableAttributedString(string:"\(data.floor!)층")
            floorString.addAttributes((self?.smtownFontAttribute)!, range: range)
            self?.floorLabel.attributedText = floorString

            range = NSRange.init(location: 0, length: (data.zone?.length())!)
            let areaString = NSMutableAttributedString(string:"\(data.zone!)구역")
            areaString.addAttributes((self?.smtownFontAttribute)!, range: range)
            self?.areaLabel.attributedText = areaString

            range = NSRange.init(location: 0, length: (data.row?.length())!)
            let rowString = NSMutableAttributedString(string:"\(data.row!)열")
            rowString.addAttributes((self?.smtownFontAttribute)!, range: range)
            self?.rowLabel.attributedText = rowString

            range = NSRange.init(location: 0, length: (data.column?.length())!)
            let seatNumberString = NSMutableAttributedString(string:"\(data.column!)번")
            seatNumberString.addAttributes((self?.smtownFontAttribute)!, range: range)
            self?.seatNumberLabel.attributedText = seatNumberString
        }
    }
    
    func closeConcertSeatInfo() {
        self.topTiltingView.backgroundColor = R.clr.boostMini.commonBgDefault()
        self.connectStatusLabel.text = BSTFacade.localizable.home.thePerformanceIsOver()
        self.arrowButton.isHidden = true
    }
    
    func updateSmallConcertInfoview() {
        self.concertInfoView.alpha = 0.7
        
        self.ddayLabel.font =  self.ddayLabel.font.withSize(12)
        self.ddayLabelWidthConstant.constant = 50
        self.ddayLabelHeightConstant.constant = 25
        
        self.concertNameLabel.font =  self.concertNameLabel.font.withSize(21)
        self.concertNameLabelHeightConstant.constant = 46
        
        self.concertDateLabel.font =  self.concertDateLabel.font.withSize(12)
        self.concertDateLabelHeightConstant.constant = 18
        
        self.concertPlaceLabel.font =  self.concertPlaceLabel.font.withSize(12)
        self.concertPlaceLabelHeightConstant.constant = 18
     }
    
    func updateDefaultConcertInforView() {
        self.concertInfoView.alpha = 1
        
        self.ddayLabel.font =  self.ddayLabel.font.withSize(15)
        self.ddayLabelWidthConstant.constant = 60
        self.ddayLabelHeightConstant.constant = 30
        
        self.concertNameLabel.font =  self.concertNameLabel.font.withSize(26)
        self.concertNameLabelHeightConstant.constant = 58
        
        self.concertDateLabel.font =  self.concertDateLabel.font.withSize(15)
        self.concertDateLabelHeightConstant.constant = 21
        
        self.concertPlaceLabel.font =  self.concertPlaceLabel.font.withSize(15)
        self.concertPlaceLabelHeightConstant.constant = 21
    }
    
    
}



