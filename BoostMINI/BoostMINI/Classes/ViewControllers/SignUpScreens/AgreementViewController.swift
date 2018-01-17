//
//  File.swift
//  Vyrl2.0
//
//  Created by wsjung on 2017. 5. 22..
//  Modified by Jack on 2017. 12. 29..
//  Copyright © 2017년 smt. All rights reserved.
//

import UIKit

import Permission
import JuseongJee_RxPermission



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
	
	/// ViewController 로딩 시, UIControl 초기화
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

		buttonCancel.rx.tap.bind {
			self.back()
		}.disposed(by: disposeBag)

		buttonDoc1.rx.tap.bind {
			
			logVerbose("cc1")
			// 이용약관 보기
			WebViewController.show(Definitions.externURLs.terms)

			}.disposed(by: disposeBag)
		
		buttonDoc2.rx.tap.bind {
			
			// 개인정보 처리방침
			WebViewController.show(Definitions.externURLs.privacy)

			}.disposed(by: disposeBag)
		
		buttonCheck.rx.tap.bind {
			
			let enable = !self.buttonCheck.isSelected
			self.buttonCheck.isSelected = enable
			self.buttonNext.isEnabled = enable
			
			}.disposed(by: disposeBag)
		
		buttonNext.rx.tap.bind {
			self.register()
			
			}.disposed(by: disposeBag)
		

	}

	
	func back() {
		BSTFacade.go.login(self, animated: false)
	}
	
	
	func register() {
		
		// intro에 있던 것.
        PermissionManager.requestDeterminingPermission {
            
        }
	}
	
	func registerPart2() {
		
		guard let token = SessionHandler.shared.token else {
			BSTFacade.ux.showToastError("token error")
			back()
			return
		}

		// TODO: 퍼미션 체크가 전부 올바르게 되었고 통과를 하였는가?...1번만 호출되어야 한다.

		BoostProfile
			.register(token,
					  registered: { profile in
						
						BSTFacade.go.home()
		}) { error in
			// TODO : error
			BSTFacade.ux.showToastError(error?.localizedDescription ?? "ERROR")
		}
	}
}


