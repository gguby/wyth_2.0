//
//  File.swift
//  Vyrl2.0
//
//  Created by wsjung on 2017. 5. 22..
//  Modified by Jack on 2017. 12. 29..
//  Copyright © 2017년 smt. All rights reserved.
//

import UIKit

class AgreementController: UIViewController {
	
	
	
	@IBOutlet weak var blurEffectView: UIVisualEffectView!
	
	@IBOutlet weak var labelHead: UILabel!
	
	@IBOutlet weak var labelComment: UILabel!
	@IBOutlet weak var scrollTextArea: UIScrollView!
	
	
	
	@IBOutlet weak var tiltingView: TiltingView!
	
	
	@IBOutlet weak var buttonDoc1: UIButton!
	@IBOutlet weak var buttonDoc2: UIButton!

	@IBOutlet weak var buttonCheck: UIButton!
	@IBOutlet weak var buttonNext: UIButton!
	@IBOutlet weak var buttonCancel: UIButton!

	
	override func viewDidLoad() {
		initUI()
		initEvents()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		// TODO : 약관동의를 하고 나야 api에 회원가입을 호출하는것인데, 약관동의 페이지에 회원 이름이 있어야 한다.. 하지만 회원가입을 하기 전 까지는 이름을 받아올 수가 없다...
		// TODO : API 수정해주시겠다고 얘기했다고는 했으나, 아직 되는건 없고 담당자는 휴가를 떠나셨다.
		// TODO : 인수인계 받는 분이 알아서 하시겠지...
		
		navigationController?.title = BSTFacade.localizable.login.titleWelcome()

		
		guard let userName = SessionHandler.shared.name else {
		
			navigationController?.isNavigationBarHidden = false
			navigationController?.hidesBarsOnTap = true
			return
		}
		navigationController?.isNavigationBarHidden = true
		navigationController?.hidesBarsOnTap = false

	}
	
	
	func initUI() {
		guard let userName = SessionHandler.shared.name else {
		
			labelHead.text = ""
			labelComment.text = ""
			
			buttonCheck.isHidden = !false
			buttonCheck.isEnabled = !true
			
			buttonCancel.isHidden = !false
			buttonCancel.isEnabled = !true
			
			buttonNext.isEnabled = !true

			return
		}
		
		buttonCheck.isHidden = false
		buttonCheck.isEnabled = true
		
		buttonCancel.isHidden = false
		buttonCancel.isEnabled = true
		
		buttonNext.isEnabled = true
		

		
		labelHead.text = BSTFacade.localizable.login.welcome(userName)
		labelComment.text = BSTFacade.localizable.login.welcomeDetail(userName)


		//BSTFacade.localizable.login.privacy()

		buttonDoc1.text = BSTFacade.localizable.login.terms()
		buttonDoc2.text = BSTFacade.localizable.login.privacy()
		buttonCancel.text = BSTFacade.localizable.login.cancelButton()
		buttonNext.text = BSTFacade.localizable.login.startButton()
	}

	
	var disposeBag = DisposeBag()
	func initEvents() {
		
		buttonDoc1.rx.tap.bind {
			
			// 이용약관 보기
			WebViewController.show(Definitions.externURLs.terms)

			}.disposed(by: disposeBag)
		
		buttonDoc1.rx.tap.bind {
			
			// 개인정보 처리방침
			WebViewController.show(Definitions.externURLs.privacy)

			}.disposed(by: disposeBag)

	}

//}, checkBoxDelegate {
//
//    @IBOutlet var btnClose: UIButton!
//
//    @IBOutlet var persnalCheckBox: CheckBox!
//    @IBOutlet var serviceCheckBox: CheckBox!
//
//    @IBOutlet var agreeLabel01: UILabel!
//    @IBOutlet var agreeLabel02: UILabel!
//
//    @IBOutlet var serviceTextView: UITextView!
//    @IBOutlet var persnalTextView: UITextView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        serviceCheckBox.label = agreeLabel01
//        persnalCheckBox.label = agreeLabel02
//
//        persnalCheckBox.delegate = self
//        serviceCheckBox.delegate = self
//
//        btnClose.backgroundColor = UIColor.ivGreyish
//        btnClose.isEnabled = false
//
//        let bottomOffset = CGPoint(x: 0, y: persnalTextView.contentSize.height - persnalTextView.bounds.size.height)
//        persnalTextView.setContentOffset(bottomOffset, animated: true)
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    }
//
//    @IBAction func pushView(sender _: AnyObject) {
//        let storyboard = UIStoryboard(name: "Login", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "profile")
//        navigationController?.pushViewController(controller, animated: true)
//    }
//
//    @IBAction func dismiss(sender _: AnyObject) {
//        navigationController?.popViewController(animated: true)
//    }
//
//    func respondCheckBox(checkBox _: CheckBox) {
//        if persnalCheckBox.isChecked && serviceCheckBox.isChecked {
//            btnClose.backgroundColor = UIColor.hexStringToUIColor(hex: "#8052F5")
//            btnClose.isEnabled = true
//        } else {
//            btnClose.backgroundColor = UIColor.ivGreyish
//            btnClose.isEnabled = false
//        }
//    }
}
