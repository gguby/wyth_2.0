//
//  ProfilePhotoViewController.swift
//  Vyrl2.0
//
//  Created by  KoMyeongbu on 2017. 5. 25..
//  Modified by Jack on 2017. 12. 29..
//  Copyright © 2017년 smt. All rights reserved.
//

import UIKit

class ProfilePhotoViewController: UIViewController {

    @IBOutlet var fileSizeLabel: UILabel!

    @IBOutlet var imageView: UIImageView!

    var image: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fileSizeLabel.layer.borderColor = UIColor.white.cgColor
        fileSizeLabel.layer.borderWidth = 1
        fileSizeLabel.layer.cornerRadius = 9.5
        fileSizeLabel.layer.masksToBounds = true

        imageView.image = image

        let imgData: NSData = NSData(data: UIImageJPEGRepresentation(image, 1.0)!)

        let imageSize: Int = imgData.length

        fileSizeLabel.text = "\(imageSize / 1024)KB"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dismissView(_: Any) {
        dismiss(animated: true, completion: nil)
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
