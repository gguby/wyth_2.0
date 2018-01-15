//
//  IntroViewController.swift
//  BoostMINI
//
//  Created by Jack on 21/12/2017.
// Copyright © 2017 IRIVER LIMITED. All rights reserved.
//

import UIKit
import Permission
import JuseongJee_RxPermission

class IntroViewController: UIViewController {
	static var actual: IntroViewController? = nil

	@IBOutlet weak var loadingMarkRightGapWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var loadingMarkFrame: UIView!
	@IBOutlet weak var loadingMark: UIView!

	
	var progressCompleted: Bool = false
	var progressAnimationWaiting: Bool = true
	let progressStep1: CGFloat = 0.5
	let progressStep2: CGFloat = 0.7
	let progressStep3: CGFloat = 0.85
	let progressStep4: CGFloat = 1.0

	override func viewDidLoad() {
		IntroViewController.actual = self
        super.viewDidLoad()


        initProperties()
    }
    
    /// initProperties() - Description:
    private func initProperties() {
        let permissionSet = PermissionSet([.camera, .bluetooth, .notifications, .photos])
        permissionSet.delegate = self
        permissionSet.permissions.forEach { (permission) in
            permission.request({ (status) in
                print(status)
            })
        }
    }
	
	deinit {
		IntroViewController.actual = nil
	}

	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		
		if progressAnimationWaiting {
			progressAnimationWaiting = false
			
			self.startLoadingMarkAnimation(progressStep1, duration:1.0)
		}
		
		
		//무조건?!
		if FunctionHouse.not(progressCompleted) {
			self.checkVersion()
		}
		

	}
	
	
	
	private var blurEffectView: UIVisualEffectView?
	func blur() {
		
		if self.blurEffectView != nil {
			return
		}
		let blurEffect = UIBlurEffect(style: .extraLight)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = self.view.frame
		self.blurEffectView = blurEffectView
		self.view.insertSubview(blurEffectView, at: 0)
	}

	
}

extension IntroViewController {
	
	func startLoadingMarkAnimation(_ to: CGFloat, duration: TimeInterval = 1.5, animated: Bool = true, completed: ((Bool) -> Swift.Void)? = nil ) {
		//let val = min(max(0, to), loadingMark.frame.size.width + 20)
		let to2 = 1.0 - min(max(0.0, to), 1.0)
		let val = min(max(0.0, self.view.frame.size.width * to2), self.view.frame.size.width * 1.0)

		logVerbose("startLoadingMarkAnimation - to:\(to)[val:\(val)], duration:\(duration), anim:\(animated) / curr:\(self.loadingMarkRightGapWidthConstraint.constant)")

		
		if FunctionHouse.not(animated) {
			self.loadingMarkRightGapWidthConstraint.constant = val
			self.view.layoutIfNeeded()
			completed?(true)
			return
		}
		//loadingMarkFrameWidthConstraint.multiplier = 0
		//self.loginButtonBottomConstraint.constant = -self.loginButton.frame.height
		
		

		logVerbose("state : \(self.view.frame.width) - \(self.loadingMarkFrame.frame.width) : \(self.loadingMarkRightGapWidthConstraint.constant)")
		
		
		if self.loadingMarkRightGapWidthConstraint.constant == val {
			logVerbose("did")
			completed?(true)
			return
		}
		
		//self.loadingMarkFrame.layer.removeAllAnimations()
		self.loadingMarkRightGapWidthConstraint.constant = val

		
		UIView.animate(withDuration: duration,
					   animations: {
						self.view.layoutIfNeeded()
		}) { fin in
			logVerbose("startLoadingMarkAnimation[\(to),\(val),\(duration)] - FIN = \(fin)")
		}
		// constraint를 사용하면 animate completion 타이밍이 안맞는다.
        FunctionHouse.runInNextMainThread(withDelay: duration) {
			logVerbose("startLoadingMarkAnimation[\(to),\(val),\(duration)] - FIN REAL %@".format(completed == nil ? "" : "closure"))
			completed?(true)

		}

	}
	
}

extension IntroViewController: PermissionSetDelegate {
    
    func permissionSet(permissionSet: PermissionSet, willRequestPermission permission: Permission) {
        print("Will request \(permission)")
    }
    
    func permissionSet(permissionSet: PermissionSet, didRequestPermission permission: Permission) {
        switch permissionSet.status {
        case .authorized:    print("all the permissions are granted")
        case .denied:        print("at least one permission is denied")
        case .disabled:      print("at least one permission is disabled")
        case .notDetermined: print("at least one permission is not determined")
        }
    }
}

extension IntroViewController {
	private func checkVersion() {
		DefaultAPI.getVersionUsingGET { [weak self] body, err in
			
			if BSTErrorTester.isFailure(err) == true {
				self?.startLoadingMarkAnimation(0.0)
				return
			}
			
			guard let data = body else {
				///BSTFacade.localizable
				BSTFacade.ux.showConfirm(BSTFacade.localizable.login.agreement(), { [weak self] isOk in
					if isOk == true {
						// retry...
						FunctionHouse.runInNextMainThread {
							if let this = self {
								this.startLoadingMarkAnimation(0.0, duration: 0.0, animated: false)
								this.startLoadingMarkAnimation(this.progressStep1)
								this.checkVersion()
							}
						}
						return
					}
				})
				
				// blockMe()??
				return
			}
			
			if let vv = data.version, vv > BSTApplication.shortVersion ?? "" {
				self?.showUpdateAlert(forceUpdate: data.forceUpdate ?? false)
				return
			}

			FunctionHouse.runInNextMainThread {
				guard let this = self else {
					return
				}
				
				this.startLoadingMarkAnimation(this.progressStep2, duration: 0.75, animated: true, completed: { fin in
					logVerbose("step2 fin. call versionConfirmed")
					this.versionConfirmed()
				})
			}
		}
	}
		
	
	func showUpdateAlert(forceUpdate: Bool = false) {
		BSTFacade.ux
			.showAlert( BSTFacade.localizable.alert.updateMessage(),
					   title: BSTFacade.localizable.alert.updateTitle(),
					   buttons: forceUpdate ? [.appStore] : [.appStore, .cancel] ) { [weak self] buttonIndex in
						guard let this = self else {
							return
						}
						
						if buttonIndex == 0 {
							FunctionHouse.OPEN_SAFARI(Definitions.externURLs.appstore)
						}
						if forceUpdate {
							this.blockMe()
						}
		}
	}
	
	func blockMe() {
		// block 해야될라낭?
		self.view.isUserInteractionEnabled = false	//??
	}
	
	
	func versionConfirmed() {
		// 버전이 옳다면 여기로 와준다.
		// 그렇다면 로그인 여부를 확인한다.
		logVerbose("Loginned? = \(SessionHandler.shared.isLoginned)")
		
		
		// TODO : 로그인이 유효한지의 여부를 서버로부터 확인해야 하면 여기에 추가한다.

		if SessionHandler.shared.isLoginned {
			// 로그인 유저
			self.startLoadingMarkAnimation(self.progressStep4, duration: 0.2, animated: true, completed: { _ in
				self.presentHome()
			})
		} else {
			// 비로그인 유저
			
			self.startLoadingMarkAnimation(self.progressStep4, duration: 0.8, animated: true, completed: { _ in
				self.presentLogin()
			})
		}
	}
	

	
	func presentHome() {
		BSTFacade.go.home(self, animated: false)
	}
	
	func presentLogin() {
		BSTFacade.go.login(self, animated: false)
	}
}
