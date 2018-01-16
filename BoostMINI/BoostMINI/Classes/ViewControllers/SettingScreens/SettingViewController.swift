//
//  SettingViewController.swift
//  BoostMINI
//
//  Created by  KoMyeongbu on 2018. 1. 9..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit

class SettingViewController: UIViewController {

    // MARK: - * IBOutlets --------------------
    @IBOutlet weak var skinCollectionView: UICollectionView!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var userNameLabel: UILabel!
    
    // MARK: - * properties --------------------
    var selectedIndexPath: IndexPath = [] {
        didSet {
            skinCollectionView.reloadData()
        }
    }

    // MARK: - * Initialize --------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initProperties()
        self.initUI()
        self.prepareViewDidLoad()
		
		userNameLabel.text = SessionHandler.shared.name
    }

    /// ViewController 로딩 시, 프로퍼티 초기화
    private func initProperties() {
        skinCollectionView.allowsMultipleSelection = false
    }

    /// ViewController 로딩 시, UIControl 초기화
    private func initUI() {
        updateSettingInformation()
    }


    func prepareViewDidLoad() {

    }

    // MARK: - * Main Logic --------------------
    func updateSettingInformation() {
        DefaultAPI.getSettingsUsingGET { (response, error) in
            guard let data = response else {
                return
            }
            
            self.userNameLabel.text = data.userName
            self.notificationSwitch.setOn(data.alarm!, animated: false)
        }
    }
    
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - * UI Events --------------------
    @IBAction func back(_ sender: UIButton) {
        pop()
    }
    
    // MARK: - * Memory Manage --------------------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension SettingViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "skinCell", for: indexPath) as! skinCollectionViewCell
        
        var borderColor: CGColor! = UIColor.clear.cgColor
        var borderWidth: CGFloat = 0
        
        if indexPath == selectedIndexPath {
            borderColor = R.clr.boostMini.commonBgPoint().cgColor
            borderWidth = 2 //or whatever you please
            cell.selectImageView.isHidden = false
        } else {
            borderColor = UIColor.clear.cgColor
            borderWidth = 0
            cell.selectImageView.isHidden = true
        }
        
        cell.imageView.layer.borderWidth = borderWidth
        cell.imageView.layer.borderColor = borderColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
    }

}

class skinCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectImageView: UIImageView!
    
}
