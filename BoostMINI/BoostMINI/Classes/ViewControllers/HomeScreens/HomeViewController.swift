//
//  HomeViewController.swift
//  BoostMINI
//
//  Created by  KoMyeongbu on 2017. 12. 27..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

private enum State {
    case closed
    case open
}

extension State {
    var opposite: State {
        switch self {
        case .open:
            return .closed
        case .closed:
            return .open
        }
    }
}


class HomeViewController: BoostUIViewController {
    
    // MARK: - * properties --------------------
	static weak var current: HomeViewController? = nil

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var skinImageView: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var alarmButton: UIButton!
    
    var selectSkinUrl : String?
    
    @available(iOS 10.0, *)
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.rx.event.bind(onNext: { (recognize) in
            self.popupViewTapped()
        }).disposed(by: disposeBag)
        return recognizer
    }()
    
    @available(iOS 10.0, *)
    private lazy var popupView: ConcertInformationView = {
        let view = ConcertInformationView.instanceFromNib()
        view.topTiltingView.addGestureRecognizer(tapRecognizer)
        
        view.arrowButton.rx.tap.bind {
            if  BSTFacade.device.isConnected {
                self.toggleViewingInformation()
            } else {
                 BSTFacade.ux.goTicketScan(currentViewController: self)
            }
            
        }.disposed(by: disposeBag)
        
        view.detailConcertInformationButton.rx.tap.bind {
            BSTFacade.ux.goDetailConcertInfoViewController(currentViewController: self)
        }.disposed(by: disposeBag)
        
        view.homeViewController = self
        return view
    }()
	
    private var bottomConstraint = NSLayoutConstraint()
    private var currentState: State = .closed
	
	
    // MARK: - * IBOutlets --------------------
    
    
    // MARK: - * Initialize --------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        self.initProperties()
        self.initUI()
        self.prepareViewDidLoad()
		
		HomeViewController.current = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if currentState == .open {
            if #available(iOS 10.0, *) {
                toggleViewingInformation()
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    /// ViewController 로딩 시, 프로퍼티 초기화
    private func initProperties() {
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuFadeStatusBar = false
    }
    
    /// ViewController 로딩 시, UIControl 초기화
    private func initUI() {
		if #available(iOS 10.0, *) {
			layout()
            
            
		}
    }

	let disposeBag = DisposeBag()
	

    func prepareViewDidLoad() {
        // 아이폰 - 카메라, 블루투스, notification 권한 요청
        PermissionManager.requestDeterminingPermission(completion: nil)
	}
	
    
    override func viewWillAppear(_ animated: Bool) {
        if BSTFacade.device.isConnected {
            //응원도구가 연동되었습니다
            popupView.connectStatusLabel.text = BSTFacade.localizable.home.connectSuccessDevice()
        } else {
            //응원도구가 연동되어 있지 않습니다.
            popupView.connectStatusLabel.text = BSTFacade.localizable.home.interlinkSupportTools()
        }
        
        updateSkinImageView()
        self.popupView.updateConcertInfo {[weak self] (totalAlarm, concertEnd) in
            if totalAlarm > 0 {
                self?.alarmButton.setImage(BSTFacade.theme.image.btnCommonAlarmOn(), for: .normal)
            } else {
                self?.alarmButton.setImage(BSTFacade.theme.image.btnCommonAlarmOff(), for: .normal)
            }
            
            if concertEnd {
                self?.popupView.topTiltingView.isUserInteractionEnabled = false
                self?.popupView.connectStatusLabel.text = BSTFacade.localizable.home.thePerformanceIsOver()
            } else {
                self?.popupView.topTiltingView.isUserInteractionEnabled = true
            }
        }
    }
    
    // MARK: - * Main Logic --------------------
	@available(iOS 10.0, *)
    private func layout() {
        view.addSubview(popupView)
        popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        popupView.topTiltingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        popupView.topTiltingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        bottomConstraint = popupView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 270)
        bottomConstraint.isActive = true
        popupView.heightAnchor.constraint(equalToConstant: 661).isActive = true
        
        popupView.topTiltingView.useCenter = false
        popupView.topTiltingView.updateDisplayTiltMask(28, animation:false)
        popupView.translatesAutoresizingMaskIntoConstraints = false
    }
    

	/// 스킨을 불러와 뿌려준다.
	///
	/// - Parameter useApi: true = 무조건 서버로부터 스킨URL을 로드한다.
	///                     false = 이미 스킨URL을 안다면 그걸로 뿌려준다. (fast)
	///                     nil = 상황에 따라 처리한다.
	func updateSkinImageView() {
		guard let skinUrl = BSTFacade.session.skinURL,
			let skinURL = URL(string: skinUrl) else {
				// 스킨 URL이 없고, 주소조차 잘못되었다면 재요청을 해야 맞다.
				self.selectSkinUrl = ""	// 이미지 로드시 스킨 리로드를 방지하기 위해 empty 값을 넣는다.
				logVerbose("updateSkinImageView 1")
				updateSkinImageUrl()
				return
		}


		logVerbose("updateSkinImageView 2")
		self.skinImageView
			.af_setImage(withURL: skinURL,
						 placeholderImage: nil,
						 filter: nil,
						 progress: nil,
						 progressQueue: DispatchQueue.global(qos: .background),
						 imageTransition: .noTransition,
						 runImageTransitionIfCached: true,
						 completion: { [weak self] image in
							
							guard let this = self else { return }
							this.skinImageView.show()
							
							let isFirstAccess = (this.selectSkinUrl == nil)
							this.selectSkinUrl = skinUrl
							if isFirstAccess {
								// selectSkinUrl이 nil이라면 최초 접근이다.
								// 다른 디바이스 등에서 스킨이 바뀌었는지 확인이 필요한 것이라면, 스킨을 리로드해보자.
								logVerbose("updateSkinImageView 3")
								this.updateSkinImageUrl()
							}
			})
		return
		
	}
	
	/// 서버로부터 스킨 이미지 주소를 가져온다.
	func updateSkinImageUrl() {
		logVerbose("updateSkinImageUrl")
		DefaultAPI.getSkinsUsingGET { [weak self] response, error in
			guard let data = response,
				let skinUrl = data.skin?.url else {
					// 스킨을 제대로 못가져왔다면 어떻게 해야 옳을까?
					
					// 네트워크가 비정상이라면 기본 이미지를 뿌려준다.옳은동작일지는 다시 생각해보자.
					self?.skinImageView.image = R.image.imgTvxqMain()
					self?.skinImageView.show()
					return
			}
			
			BSTFacade.session.skinURL = skinUrl	// skinUrl은 nil이 아니다.
			self?.updateSkinImageView()
        }
    }
    
	func popupViewTapped() {
        //티켓 정보가 없을 경우,
        if  currentState == .closed {
            
            if BSTFacade.device.isConnected {
                toggleViewingInformation()
            } else {
                BSTFacade.ux.goTicketScan(currentViewController: self)
            }
        }
    }
    
    @available(iOS 10.0, *)
    func toggleViewingInformation() {
        let state = currentState.opposite
        let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.bottomConstraint.constant = 0
                self.backgroundView.alpha = 0.7
                self.blurView.isHidden = false
                self.popupView.topTiltingView.updateDisplayTiltMask(-28, animation:true)
                self.popupView.updateSmallConcertInfoview()
                self.popupView.arrowButton.setImage(BSTFacade.theme.image.btnCommonSlideDown(), for: .normal)
            case .closed:
                self.bottomConstraint.constant = 270
                self.backgroundView.alpha = 0
                 self.blurView.isHidden = true
                self.popupView.topTiltingView.updateDisplayTiltMask(28, animation:true)
                self.popupView.updateDefaultConcertInforView()
                self.popupView.arrowButton.setImage(BSTFacade.theme.image.btnCommonSlideUp(), for: .normal)
            }
            self.view.layoutIfNeeded()
        })
        transitionAnimator.addCompletion { position in
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            }
            switch self.currentState {
            case .open:
                self.bottomConstraint.constant = 0
            case .closed:
                self.bottomConstraint.constant = 270
                
            }
        }
        transitionAnimator.startAnimation()

    }
    
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "TicketConfirmViewControllerExit" {
            
        }
    }
    
    
    // MARK: - * Memory Manage --------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeViewController : UISideMenuNavigationControllerDelegate {
    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
        self.backgroundView.alpha = 0.7
        self.popupView.dimConcertInforView()
        if currentState == .open {
            if #available(iOS 10.0, *) {
                toggleViewingInformation()
             } else {
            }
        }
    }
    
    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        self.backgroundView.alpha = 0
        self.popupView.defaultConcertInfoView()
    }
}

