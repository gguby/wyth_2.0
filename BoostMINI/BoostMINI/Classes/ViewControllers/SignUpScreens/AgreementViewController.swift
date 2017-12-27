//
//  File.swift
//  Vyrl2.0
//
//  Created by wsjung on 2017. 5. 22..
//  Copyright © 2017년 smt. All rights reserved.
//

import UIKit

class AgreementController: UIViewController, checkBoxDelegate {

    @IBOutlet var btnClose: UIButton!

    @IBOutlet var persnalCheckBox: CheckBox!
    @IBOutlet var serviceCheckBox: CheckBox!

    @IBOutlet var agreeLabel01: UILabel!
    @IBOutlet var agreeLabel02: UILabel!

    @IBOutlet var serviceTextView: UITextView!
    @IBOutlet var persnalTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        serviceCheckBox.label = agreeLabel01
        persnalCheckBox.label = agreeLabel02

        persnalCheckBox.delegate = self
        serviceCheckBox.delegate = self

        btnClose.backgroundColor = UIColor.ivGreyish
        btnClose.isEnabled = false

        let bottomOffset = CGPoint(x: 0, y: persnalTextView.contentSize.height - persnalTextView.bounds.size.height)
        persnalTextView.setContentOffset(bottomOffset, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func pushView(sender _: AnyObject) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "profile")
        navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func dismiss(sender _: AnyObject) {
        navigationController?.popViewController(animated: true)
    }

    func respondCheckBox(checkBox _: CheckBox) {
        if persnalCheckBox.isChecked && serviceCheckBox.isChecked {
            btnClose.backgroundColor = UIColor.hexStringToUIColor(hex: "#8052F5")
            btnClose.isEnabled = true
        } else {
            btnClose.backgroundColor = UIColor.ivGreyish
            btnClose.isEnabled = false
        }
    }
}
