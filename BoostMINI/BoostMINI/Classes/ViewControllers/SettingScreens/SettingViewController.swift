//
//  SettingViewController.swift
//  BoostMINI
//
//  Created by  KoMyeongbu on 2018. 1. 9..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class SettingViewController: UIViewController {

    // MARK: - * IBOutlets --------------------
    @IBOutlet weak var skinCollectionView: UICollectionView!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var withdrawButton: UIButton!
    
    // MARK: - * properties --------------------
    
    var skinDatas : [Skin]? = []
    
    
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
        updateVersionInfo()
        
        self.skinCollectionView.backgroundColor = UIColor.clear
        
        var attrs : [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12),
            NSAttributedStringKey.foregroundColor : R.clr.boostMini.commonTextBg(),
            NSAttributedStringKey.underlineStyle : 1]
        
       
        let logoutString = NSMutableAttributedString.init(string: "로그아웃", attributes: attrs)
        self.logoutButton.setAttributedTitle(logoutString, for: .normal)
        
        let updateString =  NSMutableAttributedString.init(string: "업데이트", attributes: attrs)
        self.updateButton.setAttributedTitle(updateString, for: .normal)
        
        attrs = [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12),
            NSAttributedStringKey.foregroundColor : R.clr.boostMini.textSubtitle(),
            NSAttributedStringKey.underlineStyle : 1]
        
        let withdrawString = NSMutableAttributedString.init(string: "회원탈퇴", attributes: attrs)
        self.withdrawButton.setAttributedTitle(withdrawString, for: .normal)
    }


    func prepareViewDidLoad() {

    }

    // MARK: - * Main Logic --------------------
    func updateSettingInformation() {
        DefaultAPI.getSettingsUsingGET { (response, _) in
            guard let data = response else {
                return
            }
            if let skins = data.skins {
                self.skinDatas = skins
            }
            self.userNameLabel.text = data.userName
            self.notificationSwitch.setOn(data.alarm!, animated: false)
            
            self.skinCollectionView.reloadData()
        }
    }
    
    func updateVersionInfo() {
        DefaultAPI.getVersionUsingGET { (response, _) in
            guard let data = response else {
                return
            }
            
            self.versionLabel.text = data.version
        
        }
    }
    
    
    @IBAction func setAlram(_ sender: UISwitch) {
        DefaultAPI.postAlarmsUsingPOST(alarm: sender.isOn)
    }
    
    @IBAction func logout(_ sender: UIButton) {
        DefaultAPI.signoutUsingDELETE { (_) in
            BSTFacade.go.login()
        }
    }
    
    @IBAction func withdrawAccount(_ sender: UIButton) {
        BSTFacade.ux
            .showConfirm("Boost for TVXQ!를 정말 탈퇴 하시겠습니까?") { (bool) in
                if bool == true {
                    DefaultAPI.withdrawUsingDELETE { (_) in
                         BSTFacade.go.login()
                    }
                }
            }
    }
    
    @IBAction func updateApp(_ sender: UIButton) {
       
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
        
        guard let array = self.skinDatas else {
            return 0
        }
        
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "skinCell", for: indexPath) as! skinCollectionViewCell
        
        var borderColor: CGColor! = UIColor.clear.cgColor
        var borderWidth: CGFloat = 0
        
        if let skins = self.skinDatas {
            cell.imageView.af_setImage(withURL: URL.init(string: skins[indexPath.row].url!)!)
            if skins[indexPath.row].select == true {
                borderColor = R.clr.boostMini.commonBgPoint().cgColor
                borderWidth = 2 //or whatever you please
                cell.selectImageView.isHidden = false
            } else {
                borderColor = UIColor.clear.cgColor
                borderWidth = 0
                cell.selectImageView.isHidden = true
            }
            
        }
        
        cell.imageView.layer.borderWidth = borderWidth
        cell.imageView.layer.borderColor = borderColor
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let skins = self.skinDatas {
            DefaultAPI.postSkinsUsingPOST(select: Int32(indexPath.row), completion: { (response, error) in
                guard let data = response else {
                    return
                }
            })
        }
        
        
    }

}

class skinCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectImageView: UIImageView!
    
}
