//
//  TicketScanViewController.swift
//  BoostMINI
//
//  Created by HS Lee on 10/01/2018.
//Copyright © 2018 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import AVFoundation
import Permission
import JuseongJee_RxPermission

class TicketScanViewController: UIViewController {

    // MARK: - * properties --------------------
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    var disposeBag = DisposeBag()
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]

    // MARK: - * IBOutlets --------------------

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var btnBack: UIButton! {
        willSet(v) {
            v.rx.tap.bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        }
    }
    
    // MARK: - * Initialize --------------------

    override func viewDidLoad() {

        self.initProperties()
        self.initUI()
//        self.prepareViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Permission.camera.rx.permission.subscribe(onNext: { (status: PermissionStatus) in
            switch status {
            case .authorized:
                self.prepareScan()
            case .denied, .disabled:
                PermissionError.disableCamera.cook()
            default:
                break
            }
        }).disposed(by: self.disposeBag)
    }


    private func initProperties() {
        
    }


    private func initUI() {

    }


    func prepareViewDidLoad() {
        prepareScan()
    }

    // MARK: - * Main Logic --------------------
    func prepareScan() {
        guard BSTDeviceType.isSimulator == false else {
            BSTFacade.ux.showToast("this is only for device.")
			DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                //goto next view.
                
            }
            return
        }
       
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = cameraView.layer.bounds
        cameraView.layer.addSublayer(videoPreviewLayer!)
        
        self.startScan()
    }
    
    /// a - Description:
    private func startScan() {
        
        // Start video capture.
        captureSession.startRunning()
        
        // Move the message label and top bar to the front
//        view.bringSubview(toFront: messageLabel)
//        view.bringSubview(toFront: topbar)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }
    
    private func finishScan(code: String) {
        //1. verify barcode to server
        
        //2. if ok, present ticketViewController
        
    }

    // MARK: - * UI Events --------------------


    // MARK: - * Memory Manage --------------------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension TicketScanViewController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
//            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if let code = metadataObj.stringValue {
                self.finishScan(code: code)
            }
        }
    }
}
