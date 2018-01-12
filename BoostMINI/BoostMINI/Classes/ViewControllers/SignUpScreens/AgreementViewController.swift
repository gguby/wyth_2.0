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

		}
		
		buttonCheck.isHidden = false
		buttonCheck.isEnabled = true
		
		buttonCancel.isHidden = false
		buttonCancel.isEnabled = true
		
		buttonNext.isEnabled = true
		

		
		labelHead.text = BSTFacade.localizable.login.welcome(userName)
		labelComment.text = BSTFacade.localizable.login.welcomeDetail(userName)

		
		
		//BSTFacade.localizable.login.privacy()

		buttonDoc1.text = BSTFacade.localizable.login.agreement()
		buttonDoc2.text = BSTFacade.localizable.login.privacy()
		buttonCancel.text = 
		

		buttonDoc1.setAttributedTitle(NSAttributedString(string: BSTFacade.localizable.login.agreement(), attributes: buttonDoc1.attributedTitle(for: .normal)!.attributesAtIndex(0, effectiveRange: nil)), for: .normal)
		
		buttonDoc2.setAttributedTitle(NSAttributedString(string: BSTFacade.localizable.login.privacy(), attributes: label.attributedText!.attributesAtIndex(0, effectiveRange: nil)), for: .normal)

		
		buttonCancel.setAttributedTitle(NSAttributedString(string: BSTFacade.localizable.login.cancelButton(), attributes: label.attributedText!.attributesAtIndex(0, effectiveRange: nil)), for: .normal)
		
		buttonNext.setTitle(BSTFacade.localizable.login.startButton(), for: .normal)


	}
	
	
	
	
	
//
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
