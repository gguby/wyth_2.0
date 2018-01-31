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



class AgreementController: BoostUIViewController {
	
	
	
	@IBOutlet weak var blurEffectView: UIVisualEffectView!
	
	@IBOutlet weak var labelHead: UILabel!
	
	@IBOutlet weak var labelComment: UILabel!
	@IBOutlet weak var scrollTextArea: UIScrollView!
	
	
	
	
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
		//labelTitle.text = BSTFacade.localizable.login.titleWelcome()
		
		navigationController?.interactivePopGestureRecognizer?.isEnabled = false

	}
	
	/// ViewController 로딩 시, UIControl 초기화
	func initUI() {
		let userName = SessionHandler.shared.welcomeName ?? ""
		
		buttonCheck.isHidden = false
		buttonCheck.isEnabled = true
		buttonCheck.isSelected = false
		
		buttonCancel.isHidden = false
		buttonCancel.isEnabled = true
		
		buttonNext.isEnabled = buttonCheck.isSelected
		
		labelHead.text = BSTFacade.localizable.login.welcome(userName)
		labelComment.text = BSTFacade.localizable.login.welcomeDetail(userName)


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
			WebViewController.show(Definitions.externURLs.terms)	// 이용약관 보기
			}.disposed(by: disposeBag)
		
		buttonDoc2.rx.tap.bind {
			WebViewController.show(Definitions.externURLs.privacy)	// 개인정보 처리방침
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
		// 나가므로 복원
		navigationController?.interactivePopGestureRecognizer?.isEnabled = true
		
		BSTFacade.go.login(self, animated: false)
	}
	
	
	func register() {
		
		// 아이폰 - 카메라, 블루투스, notification 권한 요청
        PermissionManager.requestDeterminingPermission { [weak self] in
            self?.registerPart2()
        }
	}
	
    ///회원가입 요청
	func registerPart2() {
		
		guard let token = SessionHandler.shared.token else {
			BSTFacade.ux.showToastError("token error")
			back()
			return
		}

		// TODO: 퍼미션 체크가 전부 올바르게 되었고 통과를 하였는가?...1번만 호출되어야 한다.

		BoostProfile
			.register(token,
					  registered: { [weak self] profile in
					
						// 나가므로 복원
						if let this = self {
							this.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
							BSTFacade.go.home()
						}
		}) { error in
			// TODO : error
			BSTFacade.ux.showToastError(error?.localizedDescription ?? "ERROR")
		}
	}
}


