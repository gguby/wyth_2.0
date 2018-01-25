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


class HomeViewController: UIViewController {
    
    // MARK: - * properties --------------------

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var skinImageView: UIImageView!
    
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
                BSTFacade.ux.goDevice(self, type: ReactorViewType.Management)
            }
        }.disposed(by: disposeBag)
        
        view.detailConcertInformationButton.rx.tap.bind {
            BSTFacade.ux.goDetailConcertInfoViewController(currentViewController: self)
        }.disposed(by: disposeBag)
        
        view.updateConcertInfo()
        view.updateConcerSeatInfo()
        view.homeViewController = self
        return view
    }()
	
    private var bottomConstraint = NSLayoutConstraint()
    private var currentState: State = .closed
	
	override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
	
    // MARK: - * IBOutlets --------------------
    
    
    // MARK: - * Initialize --------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        self.initProperties()
        self.initUI()
        self.prepareViewDidLoad()
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
       updateSkinImageView()
        
        if BSTFacade.device.isConnected {
            //응원도구가 연동되었습니다
            popupView.connectStatusLabel.text = "응원도구가 연동되었습니다."
        } else {
            //응원도구가 연동되어 있지 않습니다.
            popupView.connectStatusLabel.text = "응원도구가 연동되어 있지 않습니다"
        }
        
        if #available(iOS 10.0, *) {
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
        } else {
            // Fallback on earlier versions
        }
    }
    
    // MARK: - * Main Logic --------------------
	@available(iOS 10.0, *)
    private func layout() {
        popupView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func updateSkinImageView() {
        DefaultAPI.getSkinsUsingGET { (response, error) in
            guard let data = response else {
                return
            }
            
            self.skinImageView.af_setImage(withURL: URL.init(string: (data.skin?.url)!)!)
        }
    }
    
	func popupViewTapped() {
        //티켓 정보가 없을 경우,
        if  currentState == .closed {
            
            if BSTFacade.device.isConnected {
                toggleViewingInformation()
            } else {
                BSTFacade.ux.goDevice(self, type: ReactorViewType.Management)
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
                self.popupView.topTiltingView.updateDisplayTiltMask(-28, animation:true)
                self.popupView.updateSmallConcertInfoview()
            case .closed:
                self.bottomConstraint.constant = 270
                self.backgroundView.alpha = 0
                self.popupView.topTiltingView.updateDisplayTiltMask(28, animation:true)
                self.popupView.updateDefaultConcertInforView()
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
        if currentState == .open {
            if #available(iOS 10.0, *) {
                toggleViewingInformation()
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

