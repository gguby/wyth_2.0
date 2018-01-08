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
    
    @available(iOS 10.0, *)
    private lazy var popupView: ConcertInformationView = {
        let view = ConcertInformationView.instanceFromNib()
         view.arrowButton.addTarget(self, action: #selector(self.popupViewTapped(recognizer:)), for: .touchUpInside)
        
        return view
    }()
	
    private var bottomConstraint = NSLayoutConstraint()
    private var currentState: State = .closed
    
	@available(iOS 10.0, *)
	private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewTapped(recognizer:)))
        return recognizer
    }()
    
    // MARK: - * IBOutlets --------------------
    
    
    // MARK: - * Initialize --------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initProperties()
        self.initUI()
        self.prepareViewDidLoad()
    }
    
    
    private func initProperties() {
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuFadeStatusBar = false
    }
    
    
    private func initUI() {
		if #available(iOS 10.0, *) {
			layout()
		}
    }
    
    func prepareViewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if #available(iOS 10.0, *) {
            view.addSubview(popupView)
            popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            
            popupView.topTiltingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            popupView.topTiltingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            
            bottomConstraint = popupView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 168)
            bottomConstraint.isActive = true
            popupView.heightAnchor.constraint(equalToConstant: 600).isActive = true
            
            popupView.topTiltingView.useCenter = false
            popupView.topTiltingView.updateDisplayTiltMask(-50, animation:false)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    // MARK: - * Main Logic --------------------
	@available(iOS 10.0, *)
    private func layout() {
        popupView.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    // MARK: - * UI Events --------------------
    
    //    @IBAction func gotoInformationViewController(_ sender: UIButton) {
    //        let vc = ConcertInformationViewController()
    //        vc.modalPresentationStyle = .custom
    //        present(vc, animated: true, completion: nil)
    //    }
	
	@available(iOS 10.0, *)
    @objc private func popupViewTapped(recognizer: UITapGestureRecognizer) {
        toggleViewingInformation()
    }
    
    @available(iOS 10.0, *)
    func toggleViewingInformation() {
        let state = currentState.opposite
        let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.bottomConstraint.constant = 0
                self.backgroundView.alpha = 0.5
                self.popupView.topTiltingView.updateDisplayTiltMask(50, animation:true)
            case .closed:
                self.bottomConstraint.constant = 168
                self.backgroundView.alpha = 1
                self.popupView.topTiltingView.updateDisplayTiltMask(-50, animation:true)
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
                self.bottomConstraint.constant = 168
                
            }
        }
        transitionAnimator.startAnimation()

    }
    
    
    // MARK: - * Memory Manage --------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HomeViewController : UISideMenuNavigationControllerDelegate {
    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print(#function)
        if(currentState == .open){
            
//            toggleViewingInformation()
        }
    }
}

