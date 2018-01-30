//
//  MenuViewController.swift
//  BoostMINI
//
//  Created by  KoMyeongbu on 2018. 1. 8..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit
import RxOptional
import SideMenu
#if DEBUG
    import FLEX
#endif

class MenuViewController: UIViewController {

    // MARK: - * properties --------------------
    let disposeBag = DisposeBag()

    // MARK: - * IBOutlets --------------------

    @IBOutlet weak var diagonalImageView: UIImageView!
    
    //for debugging
	@IBOutlet weak var debugPanel: UIView?


    @IBOutlet weak var deviceButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    
    // MARK: - * Initialize --------------------
	override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initProperties()
        self.initUI()
        self.prepareViewDidLoad()
    }

    /// ViewController 로딩 시, 프로퍼티 초기화
    private func initProperties() {

    }

    /// ViewController 로딩 시, UIControl 초기화
    private func initUI() {

		self.navigationController?.view.backgroundColor = .clear
		
    #if DEBUG
		//TODO: 테스트 완료시 debugPanel만 Storyboard에서 제거하면 됨.
		//TODO: 버튼 추가를 원하면 태그를 104, 105 ... 처럼 늘리면 됨.
		
		if let debugPanel = debugPanel {
			debugPanel.isHidden = false
			let eventFuncs = [
				101 : { FLEXManager.shared().showExplorer() },
				102 : { BSTFacade.ux.goTicketScan(currentViewController: self) },
				103 : { let con = !BSTFacade.device.isConnected
					BSTFacade.device.isConnected = con
					BSTFacade.ux.showAlert("isConnected = \(con)") }
			]
			for i in 0..<eventFuncs.keys.count {
				let buttonTag = 101 + i
				if let btn = debugPanel.viewWithTag(buttonTag) as? UIButton,
					let eFunc = eventFuncs[buttonTag] {
					btn.rx.tap.bind { eFunc() }.disposed(by: disposeBag)
				}
			}
		}
    #endif
        
        self.deviceButton.rx.tap.bind {
			self.dismiss(animated: false, completion: {
				BSTFacade.ux.goDevice(HomeViewController.current ?? self, type: ReactorViewType.Management)
			})
        }.disposed(by: disposeBag)
        
    }
	
	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		dismiss(animated: false)
		return true
	}


    func prepareViewDidLoad() {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
	

    // MARK: - * Main Logic --------------------
    
    // MARK: - * UI Events --------------------
    
    @IBAction func goToYoutubeSite(_ sender: UIButton) {
        let appURL = NSURL(string: "youtube://www.youtube.com/user/SMTOWN")!
        let webURL = NSURL(string: "https://www.youtube.com/user/SMTOWN")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            // if Youtube app is not installed, open URL inside Safari
            application.open(webURL as URL)
        }
    }

	func push(_ newViewController: UIViewController?) {
		self.dismiss(animated: false) {
			guard let newVC = newViewController, let navigationController = HomeViewController.current?.navigationController else {
				return
			}
			navigationController.pushViewController(newVC, animated: true)
		}
	}

	
}


extension MenuViewController {

}
