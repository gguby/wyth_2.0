//
//  ProfileController.swift
//  Vyrl2.0
//
//  Created by wsjung on 2017. 5. 22..
//  Modified by Jack on 2017. 12. 29..
//  Copyright © 2017년 smt. All rights reserved.
//

import TOCropViewController
import UIKit
import Alamofire
// import Sharaku

class ProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {

    @IBOutlet var btnClose: UIButton!
    @IBOutlet var photoView: UIButton!
    @IBOutlet var overlabLabel: UILabel!

    @IBOutlet var checkView: UIImageView!

    @IBOutlet var signUp: UIButton!

    @IBOutlet var nickNameField: UITextField!
    @IBOutlet var introField: UITextField!
    @IBOutlet var webURLField: UITextField!
    @IBOutlet var duplicationCheckButton: UIButton!

    var type: ProfileViewType = .SignUp
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        switch type {
//        case .SignUp:
//            print("SignUp")
//        case .Modify:
//            print("modify")
//        }
//
//        overlabLabel.isHidden = true
//        duplicationCheckButton.setTitleColor(UIColor.ivGreyish, for: .disabled)
//        duplicationCheckButton.setTitleColor(UIColor.ivLighterPurple, for: .normal)
//
//        signUp.isEnabled = false
//        signUp.backgroundColor = UIColor.hexStringToUIColor(hex: "#ACACAC")
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
//
//        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(tap(sender:)))
//        view.addGestureRecognizer(tapGestureReconizer)
//    }
//
//    func tap(sender _: UITapGestureRecognizer) {
//        view.endEditing(true)
//    }
//
//    func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if view.frame.origin.y == 0 {
//                view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//
//    func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if view.frame.origin.y != 0 {
//                view.frame.origin.y += keyboardSize.height
//            }
//        }
//    }
//
//    @IBAction func dismiss(sender _: AnyObject) {
//        navigationController?.popViewController(animated: true)
//    }
//
//    @IBAction func selectPhoto(_: Any) {
//        showAlert()
//    }
//
//    @IBAction func pushView(sender _: AnyObject) {
//        let photo = photoView.imageView?.image
//
//        LoginManager.sharedInstance.signUp(homePageURL: webURLField.text!, nickName: nickNameField.text!, selfIntro: introField.text!, profile: photo!, completionHandler: {
//            self.pushView(storyboardName: "Login", controllerName: "logincomplete")
//        })
//    }
//
//    @IBAction func checkNicname(_: UIButton) {
//        duplicationCheckButton.isEnabled = false
//        LoginManager.sharedInstance.checkNickname(nickname: nickNameField.text!) { response
//            in switch response.result {
//            case let .success(json):
//                print((response.response?.statusCode)!)
//                print(json)
//
//                if (response.response?.statusCode)! == Constants.VyrlResponseCode.NickNameAleadyInUse.rawValue {
//                    self.overlabLabel.isHidden = false
//                } else if (response.response?.statusCode)! == 200 {
//                    self.checkView.isHidden = false
//                    self.duplicationCheckButton.isHidden = true
//
//                    self.signUp.isEnabled = true
//                    self.signUp.backgroundColor = UIColor.ivLighterPurple
//                }
//
//            case let .failure(error):
//                print(error)
//            }
//        }
//    }
//
//    @IBAction func changeProfile(_: UIButton) {
//        let profile = photoView.imageView?.image
//
//        let parameters: Parameters = [
//            "homePageUrl": webURLField.text!,
//            "nickName": nickNameField.text!,
//            "selfIntro": introField.text!,
//        ]
//
//        let uri = Constants.VyrlAPIURL.MYPROFILE
//        let fileName = "\(nickNameField.text!).jpg"
//
//        Alamofire.upload(multipartFormData: { multipartFormData in
//            if let imageData = UIImageJPEGRepresentation(profile!, 1.0) {
//                multipartFormData.append(imageData, withName: "profile", fileName: fileName, mimeType: "image/jpg")
//            }
//
//            for (key, value) in parameters {
//                let valueStr = value as! String
//                multipartFormData.append(valueStr.data(using: String.Encoding.utf8)!, withName: key)
//            }
//
//        }, usingThreshold: UInt64(), to: uri, method: .post, headers: Constants.VyrlAPIConstants.getHeader(), encodingCompletion: {
//            encodingResult in
//            switch encodingResult {
//            case let .success(upload, _, _):
//
//                upload.uploadProgress(closure: { progress in
//                    print(progress)
//                })
//
//                upload.responseString { response in
//                    print(response.result)
//                    print((response.response?.statusCode)!)
//                    print(response)
//
//                    if (response.response?.statusCode)! == 200 {
//                        self.navigationController?.popViewController(animated: true)
//                    }
//                }
//            case let .failure(encodingError):
//                print(encodingError.localizedDescription)
//            }
//        })
//    }
//
//    func showAlert() {
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
//
//        let showProfileAction = UIAlertAction(title: "사진 크게 보기", style: .default, handler: { (_) -> Void in
//            self.showProfileViewController()
//        })
//        let changeProfileAction = UIAlertAction(title: "프로필 사진 변경", style: .default, handler: { (_) -> Void in
//            self.changeProfile()
//        })
//        let defaultProfileAction = UIAlertAction(title: "기본 이미지로 변경", style: .default, handler: { (_) -> Void in
//
//            self.photoView.setImage(UIImage(named: "icon_user_03"), for: UIControlState.normal)
//
//            self.dismiss(animated: true, completion: {
//
//            })
//        })
//
//        if let image = self.photoView.image(for: .normal) {
//            alertController.addAction(showProfileAction)
//        }
//
//        alertController.addAction(changeProfileAction)
//        alertController.addAction(defaultProfileAction)
//
//        present(alertController, animated: true, completion: {
//            alertController.view.superview?.isUserInteractionEnabled = true
//            alertController.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
//        })
//    }
//
//    func alertControllerBackgroundTapped() {
//        dismiss(animated: true, completion: nil)
//    }
//
//    func showProfileViewController() {
//        let storyboard = UIStoryboard(name: "Login", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "ProfilePhotoViewController") as! ProfilePhotoViewController
//        vc.image = photoView.image(for: .normal)
//
//        present(vc, animated: true, completion: nil)
//    }
//
//    func changeProfile() {
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) == false {
//            return
//        }
//
//        let imagePicker = UIImagePickerController()
//
//        imagePicker.delegate = self
//        imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
//
//        present(imagePicker, animated: true, completion: nil)
//    }
//
//    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
//
//        dismiss(animated: true, completion: nil)
//
//        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//
//        let cropViewController = TOCropViewController(image: chosenImage)
//
//        cropViewController.delegate = self
//
//        present(cropViewController, animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect _: CGRect, angle _: Int) {
//
//        let vc = SHViewController(image: image)
//        vc.delegate = self
//        cropViewController.present(vc, animated: true, completion: nil)
//    }
//}
//
//extension ProfileController: SHViewControllerDelegate {
//
//    func shViewControllerImageDidFilter(image: UIImage) {
//        // Filtered image will be returned here.
//
//        photoView.setImage(image, for: UIControlState.normal)
//        photoView.layer.masksToBounds = true
//        photoView.layer.cornerRadius = photoView.frame.width / 2
//        photoView.layer.borderColor = UIColor.black.cgColor
//        photoView.layer.borderWidth = 1.0
//
//        dismiss(animated: true, completion: nil)
//    }
//
//    func shViewControllerDidCancel() {
//        // This will be called when you cancel filtering the image.
//    }
//}
//
//extension ProfileController: UITextFieldDelegate {
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if textField != nickNameField {
//            return true
//        }
//
//        overlabLabel.isHidden = true
//        duplicationCheckButton.isEnabled = false
//
//        signUp.isEnabled = false
//        signUp.backgroundColor = UIColor.hexStringToUIColor(hex: "#ACACAC")
//
//        checkView.isHidden = true
//        duplicationCheckButton.isHidden = false
//        let newLength = textField.text!.characters.count + string.characters.count - range.length
//        if newLength > 3 && newLength < 20 {
//            duplicationCheckButton.isEnabled = true
//        }
//
//        return true
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
}

enum ProfileViewType {
    case SignUp, Modify
}
