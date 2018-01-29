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

class SettingViewController: BoostUIViewController {

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
    var selectedSkin : Int?
    
    let disposeBag = DisposeBag()
    
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

    /// ViewController 로딩 시, UIControl 초기화
    private func initUI() {
        updateSettingInformation()
        updateVersionInfo()
        
        self.logoutButton.rx.tap.bind {
            DefaultAPI.signoutUsingDELETE { _ in
                SessionHandler.shared.logout()
                BSTFacade.go.login()
            }
        }.disposed(by: disposeBag)
        
        self.updateButton.rx.tap.bind {
            UIApplication.shared.openURL(URL(string: Definitions.externURLs.appstore)!)
        }.disposed(by: disposeBag)
        
        self.withdrawButton.rx.tap.bind {
            BSTFacade.ux
                .showConfirm("Boost for TVXQ!를 정말 탈퇴 하시겠습니까?") { (bool) in
                    if bool == true {
                        DefaultAPI.withdrawUsingDELETE { (_) in
                            SessionHandler.shared.logout()
                            BSTFacade.go.login()
                        }
                    }
            }
        }.disposed(by: disposeBag)
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
            self.selectedSkin = data.selectedSkin! - 1
            
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
            
            if let version = data.version,
                let shortVersion = BSTApplication.shortVersion,
                version > shortVersion {
                
                self.updateButton.isHidden = false
            } else {
                self.updateButton.isHidden = true
            }
         }
    }
    
     // MARK: - * UI Events --------------------
    @IBAction func setOnAlram(_ sender: UISwitch) {
        let alarm = AlarmPostRequest(alarm: sender.isOn)
        DefaultAPI.postAlarmsUsingPOST(request: alarm) { (response, error) in
            guard let data = response else {
                return
            }
        }
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
            if  indexPath.row == self.selectedSkin {
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
			
			let request = SkinPostRequest(select: (indexPath.row + 1))
			DefaultAPI.postSkinsUsingPOST(request: request, completion: { [weak self] (response, error) in
                guard let data = response else {
                    return
                }
                BSTFacade.ux.showToast("설정 되었습니다.")
				BSTFacade.session.skinURL = skins[indexPath.row].url
                
                self?.selectedSkin = indexPath.row
                self?.skinCollectionView.reloadData()
            })
        }
        
        
    }

}

class skinCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectImageView: UIImageView!
    
}
